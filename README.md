# Musicus – user guide

The user guide of [Musicus](https://github.com/Musicus-Sheets/Musicus): installation
(Docker or directly on a computer) and how admins, librarians and musicians
use it. Written in [Typst](https://typst.app); one source produces an HTML page
(main format, self-contained, with navigation sidebar and dark mode) and a PDF.

This repository is the submodule `docs/user-guide` of the main repository.

## Build

```sh
./build.sh          # → out/musicus-user-guide.html and out/musicus-user-guide.pdf
./build.sh 1.2.0    # the same, with the release version 1.2.0 on the title page
```

The title page names the Musicus version (`typst --input version=…`, read in
`main.typ`): the first argument of `build.sh`, else `$MUSICUS_VERSION` (the
guide site passes the release's version), else the workspace version of the
main repository's `Cargo.toml` when this is its submodule, else "dev" (a
development version).

Requires `typst` (tested with 0.15; `cargo install --locked typst-cli`). The HTML
export of Typst is still marked experimental, hence `--features html`. The
Inter font (SIL Open Font License, `fonts/Inter-LICENSE.txt`) is bundled so the
PDF looks the same everywhere.

## Structure

| Path | Content |
| --- | --- |
| `main.typ` | Entry point |
| `template.typ` | Layout for both outputs: `guide`, `ui` (button labels), `kbd`, `role`, `who`, `tip`/`note`/`warning`, `shot`/`shots` (screenshots), `cards`; HTML stylesheet |
| `chapters/01-welcome.typ` | What Musicus is, roles, how access works |
| `chapters/02-installation.typ` | Docker, direct installation, HTTPS, backups and restore, updates (snapshots, failed updates), settings |
| `chapters/03-admin.typ` | Admins: first login, navigation, accounts, groups |
| `chapters/04-librarian.typ` | Librarians: instruments, adding a piece (guided flow), editing pieces and parts, uploads, importing an archive folder, access, programmes |
| `chapters/05-member.typ` | Musicians: library, programmes, reader, annotations, account |
| `chapters/06-faq.typ` | Questions and answers |
| `images/` | Screenshots (generated, see below) |
| `tools/` | Screenshot generation |

Write button and menu names exactly as the application shows them, with
`#ui("…")`.

## Updating the screenshots

The screenshots are taken automatically from a real Musicus with example data,
so they can be regenerated after every UI change:

```sh
# 1. Sample sheets (synthetic notes)
uv run tools/make_sample_sheets.py /tmp/musicus-sheets

# 2. A fresh Musicus (empty data!), e.g. from the main repository:
docker build -t musicus:guide ../..
docker run -d --name musicus-guide -p 127.0.0.1:18080:8080 \
    -e MUSICUS_PUBLIC_URL=http://localhost:18080 musicus:guide
docker logs musicus-guide | grep invite        # admin invite URL

# 3. Screenshots
npm install --no-save playwright && npx playwright install chromium
node tools/screenshots.mjs <admin-invite-url> /tmp/musicus-sheets images

docker rm -f musicus-guide
```

`tools/screenshots.mjs` fills the server with example users, groups, scores and
programmes through the REST API and then captures every screen through the
real interface (desktop, tablet and phone sizes).
