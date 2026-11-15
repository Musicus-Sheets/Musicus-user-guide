// Layout of the Musicus user guide. One source, two outputs:
//   typst compile --font-path fonts main.typ musicus-user-guide.pdf
//   typst compile --features html --font-path fonts main.typ musicus-user-guide.html
// Every element checks `target()` and renders natively for HTML or for paged output.

#let accent = rgb("#2f5bd3")
#let accent-soft = rgb("#eef3ff")
#let ink = rgb("#1d2433")
#let muted = rgb("#5d6677")
#let role-colors = (
  admin: rgb("#b42318"),
  librarian: rgb("#7a4cc2"),
  member: rgb("#1a7f37"),
)

#let is-html() = target() == "html"

// --- Inline elements ---------------------------------------------------------

/// A label of a button, menu entry or field, exactly as shown in Musicus.
#let ui(label) = context {
  if is-html() {
    html.elem("span", attrs: (class: "ui"))[#label]
  } else {
    box(
      fill: luma(242),
      stroke: 0.5pt + luma(200),
      inset: (x: 3pt, y: 0pt),
      outset: (y: 2.5pt),
      radius: 3pt,
      text(weight: "semibold", size: 0.92em, label),
    )
  }
}

/// A keyboard key.
#let kbd(key) = context {
  if is-html() {
    html.elem("kbd")[#key]
  } else {
    box(
      stroke: (paint: luma(160), thickness: 0.6pt),
      inset: (x: 3pt, y: 0pt),
      outset: (y: 2.5pt),
      radius: 2.5pt,
      fill: luma(250),
      text(font: "DejaVu Sans Mono", size: 0.85em, key),
    )
  }
}

/// A role badge: "admin", "librarian" or "member".
#let role(name) = context {
  let label = (admin: "Admin", librarian: "Librarian", member: "Member").at(name)
  if is-html() {
    html.elem("span", attrs: (class: "role role-" + name))[#label]
  } else {
    let c = role-colors.at(name)
    box(
      fill: c.lighten(88%),
      stroke: 0.6pt + c,
      inset: (x: 4pt, y: 0pt),
      outset: (y: 2.5pt),
      radius: 8pt,
      text(size: 0.82em, weight: "bold", fill: c, label),
    )
  }
}

/// "Who can do this" line under a heading.
#let who(..names) = context {
  let badges = names.pos().map(role).join(if is-html() [ ] else { h(4pt) })
  if is-html() {
    html.elem("p", attrs: (class: "who"))[For #badges]
  } else {
    block(above: 0.4em, below: 0.9em, text(size: 0.9em, fill: muted)[For #badges])
  }
}

// --- Blocks --------------------------------------------------------------------

#let callout-style = (
  tip: (title: "Tip", color: rgb("#1a7f37"), symbol: "✓"),
  note: (title: "Good to know", color: accent, symbol: "i"),
  warning: (title: "Attention", color: rgb("#b54708"), symbol: "!"),
)

#let callout(kind, body, title: none) = context {
  let s = callout-style.at(kind)
  let heading = if title == none { s.title } else { title }
  if is-html() {
    html.elem("div", attrs: (class: "callout callout-" + kind))[
      #html.elem("p", attrs: (class: "callout-title"))[#heading]
      #body
    ]
  } else {
    block(
      width: 100%,
      fill: s.color.lighten(92%),
      stroke: (left: 3pt + s.color),
      radius: (right: 4pt),
      inset: (x: 12pt, y: 10pt),
      breakable: true,
    )[
      #grid(
        columns: (16pt, 1fr),
        column-gutter: 8pt,
        align(center, circle(radius: 7.5pt, fill: s.color, align(center + horizon, text(fill: white, weight: "bold", size: 9pt, s.symbol)))),
        [#text(weight: "bold", fill: s.color.darken(20%), heading) \ #body],
      )
    ]
  }
}
#let tip(body, title: none) = callout("tip", body, title: title)
#let note(body, title: none) = callout("note", body, title: title)
#let warning(body, title: none) = callout("warning", body, title: title)

/// A screenshot with caption. `width` applies to both outputs.
#let shot(path, caption, width: 100%, alt: none) = context {
  let a = if alt == none { caption } else { alt }
  if is-html() {
    // Embedded as data URI, so the HTML file is self-contained.
    figure(image("images/" + path, width: width, alt: if type(a) == str { a } else { none }), caption: caption)
  } else {
    figure(
      block(
        width: width,
        stroke: 0.6pt + luma(205),
        radius: 5pt,
        clip: true,
        image("images/" + path, width: 100%),
      ),
      caption: caption,
    )
  }
}

/// Two screenshots next to each other (stacked on narrow screens in HTML).
#let shots(left, right) = context {
  if is-html() {
    html.elem("div", attrs: (class: "shots"))[#left #right]
  } else {
    grid(columns: (1fr, 1fr), column-gutter: 14pt, left, right)
  }
}

/// A numbered "chapter overview" card shown at the start of the guide.
#let path-card(title, body, color: accent) = context {
  if is-html() {
    html.elem("div", attrs: (class: "card"))[
      #html.elem("p", attrs: (class: "card-title"))[#title]
      #body
    ]
  } else {
    block(
      width: 100%,
      fill: color.lighten(93%),
      stroke: 0.6pt + color.lighten(60%),
      radius: 6pt,
      inset: 11pt,
    )[#text(weight: "bold", fill: color.darken(10%), title) \ #v(-0.3em) #body]
  }
}

#let cards(..items) = context {
  if is-html() {
    html.elem("div", attrs: (class: "cards"))[#items.pos().join()]
  } else {
    grid(columns: (1fr, 1fr, 1fr), column-gutter: 10pt, ..items.pos())
  }
}

// --- HTML stylesheet -------------------------------------------------------------

#let css = ```
:root {
  --accent: #2f5bd3; --accent-soft: #eef3ff; --ink: #1d2433; --muted: #5d6677;
  --bg: #f6f7f9; --surface: #ffffff; --border: #dde1e8; --code: #f0f2f5;
  --admin: #b42318; --librarian: #7a4cc2; --member: #1a7f37;
  --tip: #1a7f37; --note: #2f5bd3; --warning: #b54708;
  color-scheme: light;
}
@media (prefers-color-scheme: dark) {
  :root {
    --accent: #8fb0ff; --accent-soft: #1c2640; --ink: #e6e9ee; --muted: #a2abba;
    --bg: #12151a; --surface: #1a1e25; --border: #2e3540; --code: #232933;
    --admin: #ff8a7a; --librarian: #c7a6ff; --member: #6fd58c;
    --tip: #6fd58c; --note: #8fb0ff; --warning: #f5b453;
    color-scheme: dark;
  }
}
* { box-sizing: border-box; }
html { scroll-behavior: smooth; scroll-padding-top: 1.5rem; }
body {
  margin: 0; background: var(--bg); color: var(--ink);
  font: 17px/1.65 "Inter", system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
}
.layout { display: grid; grid-template-columns: 19rem minmax(0, 1fr); min-height: 100vh; }
aside {
  position: sticky; top: 0; height: 100vh; overflow-y: auto; padding: 1.6rem 1.2rem 2rem;
  background: var(--surface); border-right: 1px solid var(--border); font-size: 0.9rem;
}
aside .brand { font-weight: 800; font-size: 1.25rem; color: var(--accent); margin: 0 0 1rem; }
aside nav h2 { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin: 0 0 0.6rem; }
aside nav ol { padding-left: 0.2rem; margin: 0; }
aside nav ol ol { padding-left: 1.1rem; margin: 0.15rem 0 0.4rem; }
aside nav li { margin: 0.18rem 0; }
aside nav a { color: var(--ink); text-decoration: none; display: block; padding: 0.1rem 0.4rem; border-radius: 6px; }
aside nav a:hover { background: var(--accent-soft); color: var(--accent); }
aside nav .prefix { color: var(--muted); margin-right: 0.35rem; font-variant-numeric: tabular-nums; }
main { padding: 0 3rem 6rem; max-width: 60rem; margin: 0 auto; width: 100%; }
.hero {
  margin: 0 -3rem 2.5rem; padding: 3.5rem 3rem 2.8rem; color: #fff;
  background: radial-gradient(circle at 85% 20%, #5b7fe6 0, transparent 45%), linear-gradient(135deg, #22356f, #2f5bd3);
}
.hero .clef { font-size: 3.4rem; line-height: 1; margin: 0; opacity: 0.9; }
.hero .title { font-size: 2.7rem; font-weight: 800; margin: 0.3rem 0 0.2rem; letter-spacing: -0.02em; }
.hero .subtitle { font-size: 1.2rem; margin: 0; opacity: 0.92; }
.hero .version { font-size: 0.9rem; margin: 1rem 0 0; opacity: 0.75; }
h2 { font-size: 1.9rem; margin: 3.2rem 0 0.8rem; letter-spacing: -0.01em; padding-top: 1.2rem; border-top: 1px solid var(--border); }
h3 { font-size: 1.3rem; margin: 2.2rem 0 0.5rem; }
h4 { font-size: 1.05rem; margin: 1.6rem 0 0.4rem; }
a { color: var(--accent); }
p { margin: 0.6rem 0; }
code { background: var(--code); padding: 0.1em 0.35em; border-radius: 4px; font-size: 0.88em; }
pre { background: #1d2433; color: #e8ecf3; padding: 1rem 1.2rem; border-radius: 10px; overflow-x: auto; font-size: 0.86rem; line-height: 1.5; }
pre code { background: none; padding: 0; color: inherit; }
ol, ul { padding-left: 1.5rem; }
li { margin: 0.25rem 0; }
main > ol > li::marker, .callout ol > li::marker { color: var(--accent); font-weight: 700; }
table { border-collapse: collapse; width: 100%; margin: 1rem 0; font-size: 0.93rem; background: var(--surface); border-radius: 10px; overflow: hidden; box-shadow: 0 0 0 1px var(--border); }
th, td { text-align: left; padding: 0.55rem 0.8rem; border-bottom: 1px solid var(--border); vertical-align: top; }
tr:first-child td { font-weight: 700; background: var(--accent-soft); }
tr:last-child td { border-bottom: none; }
figure { margin: 1.6rem 0; text-align: center; }
figure img { max-width: 100%; height: auto; border-radius: 10px; border: 1px solid var(--border); box-shadow: 0 8px 28px rgba(20, 30, 60, 0.12); }
figcaption { color: var(--muted); font-size: 0.88rem; margin-top: 0.6rem; }
.shots { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; align-items: start; }
.shots figure { margin: 0.6rem 0; }
.ui { display: inline-block; padding: 0 0.4em; border-radius: 5px; border: 1px solid var(--border); background: var(--surface); font-weight: 600; font-size: 0.9em; white-space: nowrap; }
kbd { font: 0.8em ui-monospace, monospace; padding: 0.05em 0.4em; border: 1px solid var(--border); border-bottom-width: 2px; border-radius: 5px; background: var(--surface); }
.role { display: inline-block; font-size: 0.78rem; font-weight: 700; padding: 0.05rem 0.55rem; border-radius: 99px; border: 1px solid currentColor; vertical-align: 0.08em; }
.role-admin { color: var(--admin); } .role-librarian { color: var(--librarian); } .role-member { color: var(--member); }
.who { color: var(--muted); font-size: 0.92rem; margin-top: -0.2rem; }
.callout { margin: 1.3rem 0; padding: 0.9rem 1.1rem 0.9rem 1.2rem; border-radius: 10px; border-left: 4px solid; background: var(--surface); box-shadow: 0 0 0 1px var(--border); }
.callout-title { font-weight: 700; margin: 0 0 0.25rem; }
.callout-tip { border-color: var(--tip); } .callout-tip .callout-title { color: var(--tip); }
.callout-note { border-color: var(--note); } .callout-note .callout-title { color: var(--note); }
.callout-warning { border-color: var(--warning); } .callout-warning .callout-title { color: var(--warning); }
.callout > :last-child { margin-bottom: 0; }
.cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin: 1.4rem 0; }
.card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 1rem 1.1rem; }
.card-title { font-weight: 700; margin: 0 0 0.3rem; }
.card p { margin: 0.2rem 0; font-size: 0.93rem; }
@media (max-width: 980px) {
  .layout { display: block; }
  aside { position: static; height: auto; border-right: none; border-bottom: 1px solid var(--border); }
  aside nav ol ol { display: none; }
  aside { padding: 1rem 1.2rem; }
  aside .brand { margin-bottom: 0.5rem; }
  main { padding: 0 1.2rem 4rem; }
  .hero { margin: 0 -1.2rem 2rem; padding: 2.4rem 1.2rem 2rem; }
  .cards, .shots { grid-template-columns: 1fr; }
}
@media print { aside { display: none; } .layout { display: block; } }
```

// --- Document setup ----------------------------------------------------------------

#let guide(title: "", subtitle: "", version: "", body) = {
  set document(title: title + " – " + subtitle)
  set text(font: ("Inter", "Noto Sans", "DejaVu Sans"), size: 10.5pt, fill: ink, lang: "en")
  // Chapters and sections are numbered; step headings below them are not.
  set heading(numbering: (..n) => if n.pos().len() <= 2 { numbering("1.1", ..n) })
  show link: set text(fill: accent)
  set par(leading: 0.7em, spacing: 1.05em)
  set list(marker: text(fill: accent, "•"), indent: 0.3em)
  set enum(numbering: n => text(fill: accent, weight: "bold", str(n) + "."), indent: 0.2em)
  show raw.where(block: true): it => context {
    if is-html() { it } else {
      block(width: 100%, fill: rgb("#1d2433"), radius: 6pt, inset: (x: 11pt, y: 9pt), text(fill: rgb("#e8ecf3"), size: 8.8pt, it))
    }
  }
  show raw.where(block: false): it => context {
    if is-html() { it } else { box(fill: luma(240), inset: (x: 2.5pt), outset: (y: 2.5pt), radius: 2.5pt, text(size: 0.9em, it)) }
  }
  set raw(theme: none)
  show figure.caption: it => context {
    if is-html() { it } else { text(size: 8.8pt, fill: muted, it) }
  }
  set table(stroke: none, inset: (x: 7pt, y: 6pt), fill: (_, y) => if y == 0 { accent-soft } else if calc.odd(y) { white } else { luma(249) })
  show table.cell.where(y: 0): set text(weight: "bold")
  // Keep tables (and their header row) on one page in the PDF.
  show table: it => context { if is-html() { it } else { block(breakable: false, it) } }

  context if is-html() {
    html.elem("style", css.text)
    html.elem("div", attrs: (class: "layout"))[
      #html.elem("aside")[
        #html.elem("p", attrs: (class: "brand"))[𝄞 Musicus]
        #outline(title: [Contents], depth: 2)
      ]
      #html.elem("main")[
        #html.elem("header", attrs: (class: "hero"))[
          #html.elem("p", attrs: (class: "clef"))[𝄞]
          #html.elem("p", attrs: (class: "title"))[#title]
          #html.elem("p", attrs: (class: "subtitle"))[#subtitle]
          #html.elem("p", attrs: (class: "version"))[#version]
        ]
        #body
      ]
    ]
  } else {
    set page(
      paper: "a4",
      margin: (x: 2.3cm, top: 2.5cm, bottom: 2.4cm),
      header: context {
        let n = counter(page).get().first()
        if n > 2 {
          set text(8pt, fill: muted)
          let chapter = query(selector(heading.where(level: 1)).before(here()))
          grid(
            columns: (1fr, auto),
            [𝄞 #title #subtitle],
            if chapter.len() > 0 { chapter.last().body },
          )
          v(-4pt)
          line(length: 100%, stroke: 0.4pt + luma(215))
        }
      },
      footer: context {
        let n = counter(page).get().first()
        if n > 2 { align(center, text(8.5pt, fill: muted, str(n - 2))) }
      },
    )
    show heading.where(level: 1): it => {
      pagebreak(weak: true)
      v(1.2cm)
      block(below: 1.1em)[
        #if it.numbering != none {
          text(size: 11pt, weight: "bold", fill: accent, tracking: 0.12em, upper("Chapter " + counter(heading).display("1")))
          linebreak()
        }
        #text(size: 26pt, weight: "extrabold", fill: ink, it.body)
        #v(-0.4em)
        #line(length: 3cm, stroke: 3pt + accent)
      ]
    }
    show heading.where(level: 2): it => block(above: 1.8em, below: 0.75em, text(size: 15pt, weight: "bold", fill: accent.darken(15%), it))
    show heading.where(level: 3): it => block(above: 1.4em, below: 0.6em, text(size: 11.5pt, weight: "bold", it))

    // Title page
    page(margin: 0pt, header: none, footer: none)[
      #place(top, rect(width: 100%, height: 62%, fill: gradient.linear(rgb("#22356f"), accent, angle: 35deg)))
      #place(top + right, dx: -1.6cm, dy: 2.2cm, text(size: 150pt, fill: white.transparentize(82%), "𝄞"))
      #place(top + left, dx: 2.3cm, dy: 7.5cm)[
        #text(size: 13pt, fill: white.transparentize(20%), weight: "medium", tracking: 0.15em, "USER GUIDE")
        #v(0.2cm)
        #text(size: 54pt, weight: "extrabold", fill: white, title)
        #v(0.1cm)
        #block(width: 12cm, text(size: 16pt, fill: white.transparentize(10%), subtitle))
      ]
      #place(bottom + left, dx: 2.3cm, dy: -3cm)[
        #set text(fill: muted)
        #grid(columns: 3, column-gutter: 8pt, role("admin"), role("librarian"), role("member"))
        #v(0.4cm)
        #text(size: 10pt, version)
      ]
    ]
    page(header: none, footer: none)[
      #text(size: 22pt, weight: "extrabold")[Contents]
      #v(0.6cm)
      #show outline.entry.where(level: 1): it => { v(0.7em); strong(it) }
      #outline(title: none, depth: 2, indent: 1.4em)
    ]
    counter(page).update(3)
    body
  }
}
