#import "../template.typ": *

= For librarians <librarian>
#who("librarian", "admin")

As librarian you keep the library in order: you add works and their parts,
upload the PDF files, decide which group reads which music, and put
together the concert programmes.

You do all of this in the pages every musician uses. Where something can
be changed, you see an extra button: #ui("+ Add piece") and #ui("Edit") in
the #ui("Library"), #ui("+ New programme") and #ui("Edit") under
#ui("Programmes"), and the editing buttons under #ui("Instruments"). In
addition, the navigation bar has #ui("Groups"). Musicians see the same
pages without these buttons.

#shot("librarian-library.png", [The library as a librarian sees it: #ui("+ Add piece") at the top, #ui("Edit") on every piece and under every part.])

== Words used in this chapter

#table(
  columns: (auto, 1fr),
  [Word], [Meaning],
  [Piece (score)], [A work or arrangement, e.g. "Florentiner Marsch". Holds the title, composer and other details.],
  [Part], [One sheet of a piece for one or more instruments, e.g. "2nd Trumpet in Bb". Each part has one PDF file.],
  [Instrument], [An entry of your ensemble's instrument list. Parts are tagged with instruments; groups get access by instrument.],
  [Programme], [A concert: date, title and the pieces in playing order.],
)

== Instruments <instruments>

Set up the instrument list once, before adding music. Use one entry per
instrument as your ensemble names it, e.g. "Trumpet", "Flute", "Horn".

+ Click #ui("Instruments") in the navigation bar.
+ Under *Add an instrument*, type the instrument (e.g. "Trumpet") and,
  optionally, its family (e.g. "Brass"). Families you already use are
  suggested while you type.
+ Click #ui("+ Add").

The list is sorted by family. To correct a name or a family, click
#ui("Edit") next to the instrument, change it and click #ui("Save").

#shot("instruments.png", [The instrument list, sorted by family, with the buttons for librarians.])

#tip[
  Keep the list short and consistent: "Trumpet" for all trumpet parts, not
  "Trumpet", "Trp." and "Trompete". Access works per instrument, so a
  misspelled duplicate would hide parts from the trumpet players.
]

#ui("Delete") removes an instrument. An instrument that is still used by
parts cannot be deleted; Musicus tells you so. Tag those parts with another
instrument first. Musicians see this list too, without the buttons.

== Adding a piece <scores>

In the #ui("Library"), click #ui("+ Add piece"). Musicus guides you through
two steps, shown at the top of the page.

=== Step 1: Details

Fill in what you know: the *title* (the only required field), subtitle,
composer, arranger, genre (e.g. "March"), the *archive number*, tags and
notes for other librarians. Then click #ui("Next: parts ›").

The *archive number* is the number of the piece's folder in your paper
archive, written as on the folder, e.g. `0304` or `A-12`. Leave it empty if
the piece has none. Two pieces may have the same number; Musicus does not
complain, because real archives sometimes do.

*Tags* are entered one by one: type a tag and press #kbd(",") or
#kbd("Enter"), and it becomes a box like the tags in the library. Type the
next one right after it. To remove a tag, click its #ui("×"), or press
#kbd("Backspace") right behind it. With the arrow keys #kbd("←") and
#kbd("→") you move between the boxes, e.g. to add a tag in front of
another one. Pasting "Christmas, New Year, Encore" creates three tags at
once. A tag you type twice is added only once.

While you type, Musicus suggests tags that are already used in the library,
so the same tag is spelt the same everywhere ("Christmas", not also
"Xmas"). Choose one with #kbd("↓") and take it with #kbd("Enter"), or tap
it. #kbd("Esc") closes the list; a comma or #kbd("Enter") without a chosen
suggestion keeps what you typed.

#shot("tag-suggestions.png", [Typing "chr" suggests the existing tag "Christmas".])

#shot("add-piece-details.png", [Step 1: the details of the piece.])

Genre, tags and the archive number are searchable. Musicians can, for
example, type "encore" to find all encore pieces, and you find the piece of
folder 0304 by typing `0304` or just `304` (separators are optional too:
`A12` finds `A-12`). The library shows the number in front of the title
(#ui("No. 0304")); #ui("Sort by archive number") above the list orders the
pieces by it, `28` before `304`, pieces without a number last.

=== Step 2: Parts and PDFs

Now add the parts one after another. For each part:

- *Instruments*: click #ui("+ Add instruments") and tick every instrument
  the part is for (@picker). A part "Flute / Piccolo" gets both.
- *Key*: for transposing instruments, choose the key from the list: B♭,
  E♭, F, C, A, D, G, E, A♭, D♭, G♭ or B♮ (H). Leave it at
  #ui("— (concert pitch)") for instruments that are not transposing.
- *Voices*: the voice or chair, e.g. `1` for the first trumpet. Letters are
  fine too, e.g. `1a` or `Solo`. If one sheet holds several voices, e.g. a
  sheet for the 1st and 2nd clarinet, enter each of them: type `1`, press
  comma, Enter or `&`, then type `2`. Every voice becomes a box (a chip);
  #kbd("Backspace") in the empty field removes the box before it, the #ui("×")
  of a box removes that one. The order you enter is kept. Musicus knows
  which voices each part contains.
- *Custom name (optional)*: usually leave it empty (see below).
- Click #ui("Choose PDF…") and select the file of this part.

Musicus names the part after its instruments, key and voices and shows the
name under the fields (*Shown as*) while you type. Several voices are joined
with "&":

#table(
  columns: (auto, auto, auto, 1fr),
  [Instruments], [Key], [Voices], [Name],
  [Trumpet], [B♭], [1], [Trumpet in B♭ 1],
  [Clarinet], [B♭], [2], [Clarinet in B♭ 2],
  [Horn], [F], [3a], [Horn in F 3a],
  [Clarinet], [B♭], [1, 2], [Clarinet in B♭ 1 & 2],
  [Flute, Oboe], [—], [1, 2], [Flute / Oboe 1 & 2],
  [Flute, Piccolo], [—], [—], [Flute / Piccolo],
)

This name appears everywhere: in the library, in programmes and in the
reader. Only if your ensemble calls a part differently, e.g. "Solo Cornet",
type that into *Custom name (optional)*; it then replaces the derived name.
If you later rename an instrument, the derived names change with it.

Click #ui("+ Add part"). The part appears in the list above with the state
of its upload: first *Uploading…*, then its version and number of pages.
The form is empty again, so you can type the next part while the upload
is still running.

#shot("add-piece-parts.png", [Step 2: three parts are uploaded; the fourth, one sheet for two voices, will be shown as "Clarinet in B♭ 1 & 2".])

When all parts are there, click #ui("Finish"). Musicus waits for running
uploads, then shows the library with the new piece highlighted.

#warning[
  A part without an instrument is not visible to any group, only to
  librarians and admins (and to groups with access to the whole piece).
]

You can also add a part without a PDF and upload the file later (see
below). In the library such pieces show a note like *1 part without PDF*.

== Changing a piece <edit-piece>

Click #ui("Edit") on the piece in the library. The edit page shows:

- *Details*: change them and click #ui("Save details").
- *Parts*: every part under its name, with its instruments, fields and
  file. Change key, voices or custom name and click #ui("Save part").
  Instruments are saved as soon as you add or remove them.
- *Add a part*: the same form as in the guided flow.
- *Delete piece*: see @deleting.

Click #ui("Done") to return to the library.

#shot("edit-piece.png", [The edit page of a piece: details at the top, then its parts.])

== Changing a single part <edit-part>

To work on one part only, click #ui("Edit") under its preview in the
library. Here you change key, voices and custom name (#ui("Save part")) and the
instruments (saved at once, like on the group page), upload its PDF (#ui("Upload PDF…")) or replace it
(#ui("Replace PDF…")). #ui("Open") shows the part in the reader.

#shot("edit-part.png", [A corrected part: version 2 is current, version 1 is kept.])

Only PDF files are accepted, up to the size your admin configured (200 MB
by default).

=== Correcting a sheet

If a part has mistakes, click #ui("Replace PDF…") and upload the corrected
file. Musicus keeps the old file as version 1 and shows the new one as
version 2; *All versions* lists them. Musicians who already wrote markings
on the old version keep them, and are offered to move them onto the new
version (see "When the librarian corrects a sheet" in @member).

=== Checking the lines of music for the system view <edit-systems>

For the system view (@member-systems) Musicus finds the lines of music
(systems) on every page by itself, a few seconds after the upload. Pages it
is unsure about are shown whole. If a line is cut in the wrong place, two
lines are joined, or a title is shown as music, click #ui("Edit systems") on
the part's edit page.

#shot("layout-editor.png", [Checking the systems of a part: one coloured band per line of music, red cut lines between them.])

Each coloured band is what the system view shows as one piece. On each page:

#table(
  columns: (auto, 1fr),
  [Control], [What it does],
  [Red line], [A cut between two bands. Drag it up or down (or click it and use the arrow keys). A line you moved is where the system view starts or ends: drag the top line of a page to the top edge, and the view shows the empty paper above the music too.],
  [#ui("×") on a line], [Removes the cut: the bands above and below become one.],
  [#ui("Split")], [Cuts a band in the middle; then drag the new line to the right place.],
  [Kind menu], [#ui("System") (music), #ui("Header (title)") (shown with the first page), #ui("Footer"), #ui("Hidden") (never shown).],
  [#ui("Show this page as a whole page")], [The system view shows this page whole, e.g. a page with an unusual layout.],
  [#ui("Save page")], [Saves the page. Every musician's system view follows it at once.],
  [#ui("Reset to automatic")], [Throws your changes away and uses the automatic detection again.],
)

Move between the pages with #ui("‹ Previous page") and #ui("Next page ›").
Your corrections belong to this file: when you upload a corrected PDF, its
pages are detected anew.

== Who may read which music <access>

Access is given to *groups*, never to single people. Your admin creates the
groups and decides who is in them (@groups); you decide what each group may
read.

+ Click #ui("Groups") in the navigation bar and select a group.
+ Under *Instruments*, click #ui("+ Add instruments") and tick the
  instruments whose parts the group may read (@picker). "Trumpets" gets
  "Trumpet".
+ Under *Whole scores (e.g. for the conductor)*, click #ui("+ Add scores")
  and tick works the group may read completely, with all parts. Search by
  title or composer.

Every change is saved at once; remove an entry with its #ui("×").

#table(
  columns: (auto, auto, 1fr),
  [Group], [Gets], [Result],
  [Trumpets], [Instrument "Trumpet"], [All trumpet parts of all works, including works added later.],
  [Conductor], [All works under *Whole scores*], [Every part of those works.],
  [Low brass], [Instruments "Trombone" and "Tuba"], [All trombone and tuba parts.],
)

#note[
  Access is always _added up_: a musician sees everything that any of their
  groups may read. Nothing can be hidden from a group by another group.
]

== Concert programmes <programmes>

A programme is a concert with its pieces in playing order. Musicians open
the programme before the concert and Musicus downloads all their sheets of
it at once (@member-programmes). During the concert, they move from one
piece to the next directly in the reader.

+ Click #ui("Programmes") in the navigation bar, then #ui("+ New programme").
+ Enter the title of the concert, choose the date, and add notes for the
  musicians (e.g. "Meet at 18:30 for the sound check").
+ Under *Pieces in concert order*, click #ui("+ Add pieces"), search by
  title or composer and tick the pieces (@picker). They are added in the
  order you tick them. A piece may appear twice, e.g. as encore: pieces
  already in the programme stay in the list, marked *already in the
  programme*.
+ Change the order with #ui("↑") and #ui("↓"), remove a piece with #ui("×").
+ Click #ui("Create programme").

To change a programme later, open it, click #ui("Edit"), and save your
changes with #ui("Save programme").

#shot("edit-programme.png", [Editing the Christmas concert: four pieces and a note for the musicians.])

#shot("programme-picker.png", [Adding two marches to the New Year concert in one go.])

Unlike groups and parts, the programme is saved only with
#ui("Create programme") or #ui("Save programme"), so you can arrange the
order first.

Musicians only see programmes in which they play at least one piece, and in
them only their own parts.

== Deleting <deleting>

- #ui("Delete piece") (at the bottom of a piece's edit page) removes the
  work with all its parts. *All musicians' markings on it are deleted too.*
  Musicus asks before it does this.
- #ui("Delete part") does the same for one part.
- #ui("Delete programme") (at the bottom of a programme's edit page)
  removes only the concert; the works stay in the library.
