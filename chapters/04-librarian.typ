#import "../template.typ": *

= For librarians <librarian>
#who("librarian", "admin")

As librarian you keep the library in order: you add works and their parts,
upload the PDF files, decide which group reads which music, and put
together the concert programmes. All of this is under #ui("Manage").

#shot("manage-overview.png", [#ui("Manage") → #ui("Library & programmes"): scores on the left, programmes and instruments on the right.])

== Words used in this chapter

#table(
  columns: (auto, 1fr),
  [Word], [Meaning],
  [Score], [A work or arrangement, e.g. "Florentiner Marsch". Holds the title, composer and other details.],
  [Part], [One sheet of a score for one or more instruments, e.g. "2nd Trumpet in Bb". Each part has one PDF file.],
  [Instrument], [An entry of your ensemble's instrument list. Parts are tagged with instruments; groups get access by instrument.],
  [Programme], [A concert: date, title and the pieces in playing order.],
)

== Instruments <instruments>

Set up the instrument list once, before adding music. Use one entry per
instrument as your ensemble names it, e.g. "Trumpet", "Flute", "Horn".

+ Go to #ui("Manage"). The *Instruments* box is on the right.
+ Type the instrument (e.g. "Trumpet") and, optionally, its family
  (e.g. "Brass").
+ Click #ui("Add").

#tip[
  Keep the list short and consistent: "Trumpet" for all trumpet parts, not
  "Trumpet", "Trp." and "Trompete". Access works per instrument, so a
  misspelled duplicate would hide parts from the trumpet players.
]

An instrument that is still used by parts cannot be deleted; tag those
parts with another instrument first.

== Adding a piece <scores>

=== 1. Create the score

+ In #ui("Manage"), type the title (and the composer, if you like) into the
  *Scores* box and click #ui("Add score").
+ The score page opens. Fill in what you know: subtitle, composer, arranger,
  genre (e.g. "March"), tags separated by commas (e.g. "Christmas,
  Encore") and notes for other librarians.
+ Click #ui("Save").

Tags and genre are searchable. Musicians can, for example, type "encore" to
find all encore pieces.

=== 2. Add the parts

Under *Parts*, type the name of the first part, e.g. "1st Trumpet in Bb",
and click #ui("Add part"). Repeat for every part.

For each part you can then set:

- *Label*: the name musicians see.
- *Voice*: the number of the voice, e.g. `1` for "1st Trumpet".
- *Key*: for transposing instruments, e.g. `Bb` or `F`.
- *Instruments*: tick every instrument the part is for. A part "Flute /
  Piccolo" gets both.

Click #ui("Save part") after changing a part.

#shot("manage-score.png", [A score with its details and the first of its parts.])

#warning[
  A part without an instrument is not visible to any group, only to
  librarians and admins (and to groups with access to the whole score).
]

=== 3. Upload the PDF files

Click #ui("Upload PDF…") next to a part and choose the file. After a moment
the part shows its version, size and number of pages, and a small preview
appears in the library.

#shot("manage-part.png", [A part after the upload: version 1, size, pages; #ui("Open") shows it, #ui("Replace PDF…") uploads a corrected file.], width: 85%)

Only PDF files are accepted, up to the size your admin configured (200 MB
by default).

=== Correcting a sheet

If a part has mistakes, click #ui("Replace PDF…") and upload the corrected
file. Musicus keeps the old file as version 1 and shows the new one as
version 2. Musicians who already wrote markings on the old version keep
them, and are offered to move them onto the new version (see
@member-versions).

== Who may read which music <access>

Access is given to *groups*, never to single people. Your admin creates the
groups and decides who is in them (@groups); you decide what each group may
read.

+ Go to #ui("Manage") → #ui("Groups & access") and select a group.
+ Under *Instruments*, tick the instruments whose parts the group may read.
  "Trumpets" gets "Trumpet".
+ Under *Whole scores (e.g. for the conductor)*, tick works the group may
  read completely, with all parts. Use the filter field to find works
  quickly.
+ Click #ui("Save").

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

+ In #ui("Manage"), type the title of the concert into the *Programmes* box,
  choose the date, and click #ui("Add programme").
+ On the programme page, pick a piece under #ui("Add a piece…") and click
  #ui("Add"). Repeat in playing order; a piece may appear twice, e.g. as
  encore.
+ Change the order with #ui("↑") and #ui("↓"), remove a piece with #ui("×").
+ Add notes for the musicians (e.g. "Meet at 18:30 for the sound check").
+ Click #ui("Save programme").

#shot("manage-programme.png", [The Christmas concert with four pieces and a note for the musicians.])

Musicians only see programmes in which they play at least one piece, and in
them only their own parts.

== Deleting

- #ui("Delete score") removes the work with all its parts. *All musicians'
  markings on it are deleted too.* Musicus asks before it does this.
- #ui("Delete") on a part does the same for one part.
- #ui("Delete programme") removes only the concert; the works stay in the
  library.
