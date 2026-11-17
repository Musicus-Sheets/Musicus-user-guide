// Takes all screenshots of the user guide from a running Musicus server.
//
//   node tools/screenshots.mjs <admin-invite-url> <sample-sheets-dir> <images-dir>
//
// Needs a FRESH server (empty data directory) with the web client, and the
// sample sheets from tools/make_sample_sheets.py. Requires Playwright
// (`npm install playwright && npx playwright install chromium`).

import { chromium } from 'playwright';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';

const [inviteUrl, sheetsDir, outDir] = process.argv.slice(2);
if (!inviteUrl || !sheetsDir || !outDir) {
  console.error('usage: node tools/screenshots.mjs <admin-invite-url> <sheets-dir> <images-dir>');
  process.exit(2);
}
const base = new URL(inviteUrl).origin;
const manifest = JSON.parse(readFileSync(join(sheetsDir, 'manifest.json'), 'utf8'));
const ADMIN_PW = 'admin-password-1';
const PW = 'guide-password-1';

// --- REST helpers (bearer token) -------------------------------------------
async function api(method, path, token, body, raw) {
  // A tablet user agent, so these sessions look like real devices in the account screenshot.
  const headers = { 'user-agent': 'Mozilla/5.0 (iPad; CPU OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1' };
  if (token) headers.authorization = `Bearer ${token}`;
  let payload;
  if (raw) {
    payload = raw;
  } else if (body !== undefined) {
    headers['content-type'] = 'application/json';
    payload = JSON.stringify(body);
  }
  const r = await fetch(base + '/api' + path, { method, headers, body: payload });
  if (!r.ok) throw new Error(`${method} ${path}: ${r.status} ${await r.text()}`);
  return r.status === 204 ? null : r.json();
}
const login = async (username, password) =>
  (await api('POST', '/auth/login', null, { username, password, bearer: true })).token;
async function createUser(admin, username, display_name, role) {
  const c = await api('POST', '/users', admin, { username, display_name, role });
  await api('POST', `/auth/invites/${c.invite.token}`, null, { password: PW });
  return c.user.id;
}

const browser = await chromium.launch();
const shot = async (page, name, opts = {}) => {
  await page.waitForTimeout(400);
  await page.screenshot({ path: join(outDir, `${name}.png`), ...opts });
  console.log('shot', name);
};

// --- Admin: first login through the invite link ------------------------------
const UA = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0 Safari/537.36';
const TABLET_UA = 'Mozilla/5.0 (iPad; CPU OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1';
const desktop = { viewport: { width: 1280, height: 820 }, deviceScaleFactor: 1.5, userAgent: UA };
// Screenshot of the centred login/invite card with some margin.
async function shotCard(page, name) {
  await page.waitForTimeout(300);
  const b = await page.locator('.card').first().boundingBox();
  const m = 28;
  await page.screenshot({ path: join(outDir, `${name}.png`), clip: { x: b.x - m, y: b.y - m, width: b.width + 2 * m, height: b.height + 2 * m } });
  console.log('shot', name);
}
// Opens an assignment picker, ticks the named entries (searching each) and applies them.
async function pickEntries(page, scope, button, names) {
  await scope.getByRole('button', { name: button }).click();
  const panel = page.locator('.picker-panel');
  for (const name of names) {
    await panel.getByRole('combobox').fill(name);
    await panel.getByRole('option', { name }).first().click();
  }
  await panel.getByRole('button', { name: /^Add \d+$/ }).click();
  await panel.waitFor({ state: 'detached' });
}
const adminCtx = await browser.newContext(desktop);
const a = await adminCtx.newPage();
await a.goto(inviteUrl);
await a.getByLabel('New password (at least 8 characters)').fill(ADMIN_PW);
await a.getByLabel('Repeat password').fill(ADMIN_PW);
await shotCard(a, 'admin-invite');
await a.getByRole('button', { name: 'Set password and log in' }).click();
await a.getByRole('heading', { name: 'Library' }).waitFor();
await shot(a, 'admin-empty-library');

// --- Example data through the API -------------------------------------------
const admin = await login('admin', ADMIN_PW);
const instruments = {};
// A realistic wind band, so the assignment pickers have something to search.
for (const [name, family] of [['Trumpet', 'Brass'], ['Trombone', 'Brass'], ['Flute', 'Woodwind'], ['Clarinet', 'Woodwind'],
  ['Flugelhorn', 'Brass'], ['French horn', 'Brass'], ['Euphonium', 'Brass'], ['Tuba', 'Brass'], ['Piccolo', 'Woodwind'],
  ['Oboe', 'Woodwind'], ['Bassoon', 'Woodwind'], ['Alto saxophone', 'Woodwind'], ['Tenor saxophone', 'Woodwind'],
  ['Drum kit', 'Percussion'], ['Glockenspiel', 'Percussion'], ['Timpani', 'Percussion']]) {
  instruments[name] = (await api('POST', '/instruments', admin, { name, family })).id;
}
const anna = await createUser(admin, 'anna', 'Anna Berger', 'member');
const ben = await createUser(admin, 'ben', 'Ben Keller', 'member');
const tom = await createUser(admin, 'tom', 'Tom Wagner', 'member');
const carla = await createUser(admin, 'carla', 'Carla Neumann', 'librarian');
const maria = await createUser(admin, 'maria', 'Maria Hofer', 'member');
await api('POST', '/users', admin, { username: 'lena', display_name: 'Lena Schmid', role: 'member' });
// More musicians, so the member picker has a realistic list.
for (const [u, d] of [['jonas', 'Jonas Bauer'], ['sophie', 'Sophie Wimmer'], ['lukas', 'Lukas Huber'], ['eva', 'Eva Gruber'],
  ['felix', 'Felix Brandstätter'], ['julia', 'Julia Moser'], ['david', 'David Pichler'], ['hanna', 'Hanna Steiner'],
  ['niklas', 'Niklas Mayr'], ['zoe', 'Zoë Lechner'], ['matthias', 'Matthias Berger'], ['clara', 'Clara Aigner']]) {
  await createUser(admin, u, d, 'member');
}

const scoreIds = [];
const partIds = {};
// Parts get no custom name: Musicus derives it from instrument, key and voice.
const partName = (p) => `${p.instrument}${p.transposition ? ` in ${p.transposition.replace('b', '♭')}` : ''}${p.voice ? ` ${p.voice}` : ''}`;
async function addParts(si, scoreId, which) {
  for (const pi of which) {
    const p = manifest.parts[pi];
    const part = await api('POST', `/scores/${scoreId}/parts`, admin, {
      instrument_ids: [instruments[p.instrument]], voice: p.voice == null ? null : String(p.voice), transposition: p.transposition,
    });
    partIds[`${si}-${pi}`] = part.id;
    await api('PUT', `/parts/${part.id}/file`, admin, undefined, readFileSync(join(sheetsDir, `score${si}-part${pi}.pdf`)));
  }
}
const allParts = manifest.parts.map((_, i) => i);
// The last score is added through the guided flow below, the others directly.
for (const [si, s] of manifest.scores.slice(0, -1).entries()) {
  const score = await api('POST', '/scores', admin, {
    title: s.title, composer: s.composer, arranger: s.arranger ?? null, genre: s.genre, tags: s.tags,
  });
  scoreIds.push(score.id);
  await addParts(si, score.id, allParts);
}

// --- Librarian: adding a piece with the guided flow ---------------------------
const lastIndex = manifest.scores.length - 1;
const last = manifest.scores[lastIndex];
await a.goto(base + '/');
await a.getByRole('link', { name: 'Add piece' }).click();
await a.getByRole('heading', { name: 'Add piece' }).waitFor();
await a.getByLabel('Title', { exact: true }).fill(last.title);
await a.getByLabel('Composer').fill(last.composer);
await a.getByLabel('Arranger').fill(last.arranger ?? '');
await a.getByLabel('Genre').fill(last.genre);
// Tags become chips after a comma; the last one is still being typed.
await a.locator('.tag-input input.tag-entry').click();
await a.keyboard.type(last.tags.map((t) => `${t},`).join(''));
await a.keyboard.type('Hymn');
await shot(a, 'add-piece-details');
await a.getByRole('button', { name: 'Next: parts' }).click();
const form = a.locator('form.new-part');
for (const pi of [0, 1, 2]) {
  const p = manifest.parts[pi];
  await pickEntries(a, form, '+ Add instruments', [p.instrument]);
  if (p.transposition) await form.getByLabel('Key').selectOption(p.transposition);
  if (p.voice) await form.getByLabel('Voice').fill(String(p.voice));
  await form.locator('input[type=file]').setInputFiles(join(sheetsDir, `score${lastIndex}-part${pi}.pdf`));
  await form.getByRole('button', { name: '+ Add part' }).click();
  await a.locator('.added-parts li', { hasText: partName(p) }).getByText(/Version 1/).waitFor({ timeout: 30000 });
}
// The next part entered, ready to be added: the name is shown live.
await pickEntries(a, form, '+ Add instruments', ['Clarinet']);
await form.getByLabel('Key').selectOption('Bb');
await form.getByLabel('Voice').fill('1');
await a.evaluate(() => window.scrollTo(0, 0));
await shot(a, 'add-piece-parts', { fullPage: true });
await a.getByRole('button', { name: 'Finish' }).click();
await a.locator('.score.focus').waitFor();
const created = (await api('GET', '/scores', admin)).find((x) => x.title === last.title);
scoreIds.push(created.id);
for (const [pi, p] of manifest.parts.entries()) {
  const part = created.parts.find((x) => x.display_name === partName(p));
  if (part) partIds[`${lastIndex}-${pi}`] = part.id;
}
await addParts(lastIndex, created.id, [3, 4]);

const group = async (name, members, instr, scores = []) => {
  const g = await api('POST', '/groups', admin, { name });
  await api('PUT', `/groups/${g.id}/members`, admin, { ids: members });
  await api('PUT', `/groups/${g.id}/instrument-grants`, admin, { ids: instr.map((i) => instruments[i]) });
  await api('PUT', `/groups/${g.id}/score-grants`, admin, { ids: scores });
};
await group('Trumpets', [anna, tom], ['Trumpet', 'Flugelhorn']);
await group('Flutes', [ben], ['Flute']);
await group('Low brass', [], ['Trombone']);
await group('Conductor', [maria], [], scoreIds);
const prog = await api('POST', '/programmes', admin, { title: 'Christmas Concert 2026', date: '2026-12-20', notes: 'Meet at 18:30 for the sound check.' });
await api('PUT', `/programmes/${prog.id}/items`, admin, { ids: [scoreIds[3], scoreIds[0], scoreIds[2], scoreIds[1]] });
const prog2 = await api('POST', '/programmes', admin, { title: 'New Year Concert 2027', date: '2027-01-01' });
await api('PUT', `/programmes/${prog2.id}/items`, admin, { ids: [scoreIds[2], scoreIds[1]] });

// --- Admin / librarian pages -------------------------------------------------
await a.goto(base + '/');
await a.getByText('Florentiner Marsch').first().waitFor();
await a.waitForTimeout(800);
await shot(a, 'librarian-library');
await a.goto(`${base}/scores/${scoreIds[0]}/edit`);
await a.locator('.part-editor').first().waitFor();
await shot(a, 'edit-piece');
// Tag suggestions: an existing tag offered while typing.
await a.goto(`${base}/scores/${scoreIds[2]}/edit`);
await a.locator('.tag-input .tag-chip').first().waitFor();
await a.locator('.tag-input input.tag-entry').click();
await a.keyboard.type('chr');
await a.locator('ul.suggest li').first().waitFor();
await a.keyboard.press('ArrowDown');
const tagBox = await a.locator('.tag-input').boundingBox();
await shot(a, 'tag-suggestions', { clip: { x: tagBox.x - 24, y: tagBox.y - 60, width: tagBox.width + 48, height: 240 } });
await a.keyboard.press('Escape');
await a.goto(base + '/instruments');
await a.locator('.instrument-list .row', { hasText: 'Trumpet' }).waitFor();
await shot(a, 'instruments');
await a.goto(`${base}/programmes/${prog.id}/edit`);
await a.getByText('Pieces in concert order').waitFor();
await a.locator('ol.items li').first().waitFor();
await shot(a, 'edit-programme', { fullPage: true });
await a.goto(base + '/groups');
await a.locator('.selectable li', { hasText: 'Trumpets' }).click();
await a.getByRole('heading', { name: 'Trumpets' }).waitFor();
await a.locator('.chip').first().waitFor();
await shot(a, 'groups', { fullPage: true });
// The member picker open: a search typed, two people ticked.
await a.getByRole('button', { name: '+ Add members' }).click();
const panel = a.locator('.picker-panel');
await panel.getByRole('combobox').fill('Ber');
await panel.getByRole('option', { name: /Matthias Berger/ }).click();
await panel.getByRole('combobox').fill('');
await panel.getByRole('option', { name: /Sophie Wimmer/ }).click();
await panel.getByRole('combobox').fill('er');
await shot(a, 'groups-picker');
await panel.getByRole('button', { name: 'Add 2' }).click();
await a.locator('.assign-actions .ok', { hasText: 'Saved' }).waitFor();
// Undo, so the example data stays as described.
for (const n of ['Matthias Berger', 'Sophie Wimmer']) {
  await a.getByRole('button', { name: `Remove ${n}` }).click();
  await a.locator('.assign-actions .ok', { hasText: 'Saved' }).waitFor();
}
// Programme pieces from the picker.
await a.goto(`${base}/programmes/${prog2.id}/edit`);
await a.locator('ol.items li').first().waitFor();
await a.getByRole('button', { name: '+ Add pieces' }).click();
await a.locator('.picker-panel').getByRole('combobox').fill('marsch');
await a.locator('.picker-panel').getByRole('option', { name: /Radetzky/ }).click();
await a.locator('.picker-panel').getByRole('option', { name: /Florentiner/ }).click();
await shot(a, 'programme-picker');
await a.keyboard.press('Escape');
await a.goto(base + '/users');
await a.getByPlaceholder('Username').fill('paul');
await a.getByPlaceholder('Display name').fill('Paul Fischer');
await a.getByRole('button', { name: 'Create and get invite link' }).click();
await a.locator('.card.highlight').waitFor();
await shot(a, 'users', { fullPage: true });

// --- Member pages -------------------------------------------------------------
const memberCtx = await browser.newContext(desktop);
const m = await memberCtx.newPage();
await m.goto(base + '/login');
await m.getByLabel('Username').fill('anna');
await m.getByLabel('Password').fill(PW);
await shotCard(m, 'login');
await m.getByRole('button', { name: 'Log in' }).click();
await m.getByText('Florentiner Marsch').first().waitFor();
await m.waitForTimeout(1000);
await shot(m, 'member-library');
await m.getByPlaceholder('Search title, composer, tag…').fill('strauss');
await m.waitForTimeout(900);
await shot(m, 'member-search');
await m.goto(base + '/programmes');
await m.getByText('Christmas Concert 2026').waitFor();
await shot(m, 'member-programmes');
await m.getByRole('link', { name: /Christmas Concert 2026/ }).click();
await m.getByText(/sheets ready/).waitFor({ timeout: 30000 });
await m.waitForTimeout(800);
await shot(m, 'member-programme');
await m.goto(base + '/account');
await m.getByText('Logged-in devices').waitFor();
await shot(m, 'member-account');

// --- Reader on a tablet ------------------------------------------------------
const tablet = await browser.newContext({ viewport: { width: 834, height: 1112 }, deviceScaleFactor: 1.5, userAgent: TABLET_UA });
const t = await tablet.newPage();
t.on('dialog', (d) => d.accept('Breathe here!'));
await t.goto(base + '/login');
await t.getByLabel('Username').fill('anna');
await t.getByLabel('Password').fill(PW);
await t.getByRole('button', { name: 'Log in' }).click();
await t.getByText('Florentiner Marsch').first().waitFor();
await t.goto(`${base}/programmes/${prog.id}/parts/${partIds['0-1']}`);
const rendered = async () => {
  await t.waitForFunction(() => {
    const c = document.getElementById('page-canvas');
    return c && c.style.width !== '';
  }, null, { timeout: 30000 });
  await t.waitForTimeout(600);
};
await rendered();
await shot(t, 'reader');

await t.getByRole('button', { name: /Draw/ }).click();
const box = await t.locator('#ink-canvas').boundingBox();
const at = (fx, fy) => [box.x + box.width * fx, box.y + box.height * fy];
async function stroke(points) {
  await t.mouse.move(...at(...points[0]));
  await t.mouse.down();
  for (const p of points.slice(1)) await t.mouse.move(...at(...p), { steps: 6 });
  await t.mouse.up();
}
// A red circle around a bar.
const circle = [];
for (let i = 0; i <= 24; i += 1) circle.push([0.42 + 0.09 * Math.cos(i / 24 * 2 * Math.PI), 0.32 + 0.035 * Math.sin(i / 24 * 2 * Math.PI)]);
await stroke(circle);
// Highlight a line.
await t.getByRole('button', { name: 'Highlighter' }).click();
await stroke([[0.1, 0.495], [0.88, 0.495]]);
// Blue pen: a "cresc." hairpin.
await t.getByRole('button', { name: 'Pen' }).click();
await t.locator('button.swatch[title="Blue"]').click();
await stroke([[0.55, 0.62], [0.8, 0.605]]);
await stroke([[0.55, 0.62], [0.8, 0.635]]);
// A sharp and a glasses stamp, and a text note.
await t.locator('select.stamps').selectOption({ index: 4 });
await t.mouse.click(...at(0.3, 0.215));
await t.locator('select.stamps').selectOption({ index: 3 });
await t.mouse.click(...at(0.08, 0.40));
await t.getByRole('button', { name: 'Text' }).click();
await t.mouse.click(...at(0.12, 0.74));
await t.locator('.save-status', { hasText: /^Saved$/ }).waitFor({ timeout: 15000 });
await shot(t, 'reader-draw');
await t.getByRole('button', { name: /Done/ }).click();
await t.getByTitle('Annotation sets').click();
await t.getByRole('heading', { name: 'Annotation sets' }).waitFor();
await shot(t, 'reader-sets');
await t.getByRole('button', { name: 'Close' }).click();

// A corrected upload: the set now belongs to an older version.
await api('PUT', `/parts/${partIds['0-1']}/file`, admin, undefined, readFileSync(join(sheetsDir, 'score0-part1-v2.pdf')));
await t.reload();
await rendered();
await t.getByText('Move them to the current version').waitFor();
await shot(t, 'reader-version');

// The system view on an 8" tablet in landscape.
await t.setViewportSize({ width: 1280, height: 800 });
await t.getByRole('button', { name: /Systems/ }).click();
await t.locator('.system-view .page-segment').first().waitFor({ timeout: 30000 });
await t.waitForFunction(() => [...document.querySelectorAll('.system-view .page-segment canvas:first-child')].every((c) => c.style.width !== ''),
  null, { timeout: 30000 });
await t.keyboard.press('ArrowRight');
await t.waitForTimeout(1500);
await shot(t, 'reader-systems');
await t.getByRole('button', { name: /Systems/ }).click();
await t.setViewportSize({ width: 834, height: 1112 });

// The system editor of the corrected part (librarian).
await a.goto(`${base}/parts/${partIds['0-1']}/systems`);
await a.locator('.layout-overlay .band').first().waitFor({ timeout: 30000 });
await a.waitForTimeout(800);
await shot(a, 'layout-editor');

// The corrected part in its edit view, with both versions.
await a.goto(`${base}/parts/${partIds['0-1']}/edit`);
await a.getByText('All versions (2)').waitFor();
await shot(a, 'edit-part');

// --- Phone ------------------------------------------------------------------
const phone = await browser.newContext({ viewport: { width: 390, height: 780 }, deviceScaleFactor: 2, userAgent: TABLET_UA.replace('iPad', 'iPhone') });
const ph = await phone.newPage();
await ph.goto(base + '/login');
await ph.getByLabel('Username').fill('ben');
await ph.getByLabel('Password').fill(PW);
await ph.getByRole('button', { name: 'Log in' }).click();
await ph.getByText('Florentiner Marsch').first().waitFor();
await ph.waitForTimeout(900);
await shot(ph, 'phone-library');
await ph.getByRole('button', { name: 'Menu' }).click();
await shot(ph, 'phone-menu');

// The picker on a phone (as the admin).
const adminPhone = await phone.browser().newContext({ viewport: { width: 390, height: 780 }, deviceScaleFactor: 2, userAgent: TABLET_UA.replace('iPad', 'iPhone') });
const ap = await adminPhone.newPage();
await ap.goto(base + '/login');
await ap.getByLabel('Username').fill('admin');
await ap.getByLabel('Password').fill(ADMIN_PW);
await ap.getByRole('button', { name: 'Log in' }).click();
await ap.getByRole('heading', { name: 'Library' }).waitFor();
await ap.goto(base + '/groups');
await ap.locator('.selectable li', { hasText: 'Flutes' }).click();
await ap.getByRole('button', { name: '+ Add instruments' }).click();
await ap.locator('.picker-panel').getByRole('combobox').fill('wood');
await ap.locator('.picker-panel').getByRole('option', { name: /Piccolo/ }).click();
await shot(ap, 'phone-picker');
await ap.keyboard.press('Escape');

await browser.close();
console.log('done', { carla, ben, tom, maria });
