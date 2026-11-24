#import "../template.typ": *

= For musicians <member>
#who("member", "librarian", "admin")

This chapter is for everybody who plays: how to log in, find your parts,
prepare a concert, read on stage and write your own markings.

== Logging in

*The first time*, you get a personal link from your admin. Open it, choose a
password (at least 8 characters), type it again, and click
#ui("Set password and log in"). That's all, you are in.

*Afterwards*, open the address of your Musicus (ask your admin, e.g.
`https://sheets.example.org`), enter your username and password, and click
#ui("Log in").

#shot("login.png", [The login page.], width: 55%)

You stay logged in on that device for weeks, so you will rarely see this
page on your own tablet.

#tip(title: [Put Musicus on your home screen])[
  On a tablet or phone, use your browser's "Add to home screen" function.
  Musicus then opens like an app.
]

== Your library

After logging in you see the *Library*: every work you play in, each with
small previews of your parts. You only see your own parts. If a work is
missing, ask your librarian (see @faq).

#shot("member-library.png", [The library of a trumpet player: each work with the trumpet parts.])

Type into the search field to find a work by title, composer, genre, tag,
archive number (the number of the paper folder, if your librarian entered
it) or the name of one of your parts (e.g. "trumpet 2").
You don't need accents or complete words: "fucik" finds "Fučík", "flor"
finds "Florentiner Marsch".

#shot("member-search.png", [Searching for "strauss" finds both works by the Strauss family.])

Tap a preview to open the part in the reader.

== Preparing a concert <member-programmes>

Under #ui("Programmes") you find the concerts you play in, newest first.

#shots(
  shot("member-programmes.png", [All your programmes.]),
  shot("member-programme.png", [A programme, ready to play.]),
)

When you open a programme, Musicus *downloads all your sheets for it at
once* and shows the progress at the top. As soon as it says
"All … sheets ready offline in this tab", every piece opens instantly, even
if the Wi-Fi in the concert hall is slow or fails.

#tip(title: [Before every rehearsal and concert])[
  Open the programme while you still have good Wi-Fi, wait for the green
  "ready" message, and keep the browser tab open. Open the pieces from the
  programme, not from the library: then the reader knows the order and takes
  you straight to the next piece.
]

#note[
  The downloaded sheets are kept only as long as the browser tab is open.
  Musicus deliberately stores nothing permanently on your device.
]

== Reading

The reader shows one page at a time, as large as your screen allows -- or,
in the system view (@member-systems), whole lines of music in a larger size.

#shot("reader.png", [The reader on a tablet.], width: 62%)

The bar at the top, from left to right:

#table(
  columns: (auto, 1fr),
  [Button], [What it does],
  [#ui("‹")], [Back to the programme or library.],
  [Title], [The work and your part.],
  [#ui("1 / 2")], [Current page and number of pages.],
  [#ui("☰ Systems")], [Switches between whole pages and the system view (@member-systems).],
  [#ui("M")], [Only in the system view: the size of the music (S, M, L, XL).],
  [#ui("✎ Draw")], [Switches to drawing (see @member-markings).],
  [#ui("☰")], [Your annotation sets.],
  [#ui("◉")], [Shows or hides your markings.],
  [#ui("⛶")], [Full screen.],
)

=== Turning pages

#table(
  columns: (auto, auto),
  [Next page], [Previous page],
  [Tap the right third of the page], [Tap the left third of the page],
  [Swipe to the left], [Swipe to the right],
  [#kbd("→") #kbd("↓") #kbd("Page Down") #kbd("Space")], [#kbd("←") #kbd("↑") #kbd("Page Up")],
)

*Page-turn pedals* (Bluetooth foot pedals) work out of the box: they send
exactly these keys. Pair the pedal with your tablet like a keyboard.

When the part was opened from a programme, turning past the last page opens
*your part of the next piece*, and turning back from the first page opens
the previous piece. On the last page you also see a #ui("Next piece ›")
button.

The screen stays on while the reader is open, so it does not dim in the
middle of a piece.

=== System view: larger music on small tablets <member-systems>

On a small tablet a whole page is often too small to read. Tap
#ui("☰ Systems"): the reader then shows as many *whole lines of music*
(systems) as fit on the screen at the size you chose. You still see your
original sheet, just a section of it: from the first line shown to the last,
with everything in between, cut to the width of the music. The view always
starts and ends with a whole line, never in the middle of one. Turn the
tablet sideways (landscape) for the largest notes.

#shot("reader-systems.png", [The system view on an 8-inch tablet in landscape: the last line of the previous view is repeated at the top.], width: 90%)

- *Size:* choose #ui("S"), #ui("M"), #ui("L") or #ui("XL") next to the
  switch (the smallest height of a staff: about 5, 6, 7 or 8 mm). A larger
  size shows fewer lines at a time. The size stays the same from view to view.
  If the music is wider than your screen, it is shown as wide as the screen
  allows.
- *Turning* works as with pages (pedal, keys, taps, swipes). When at least
  three lines fit on the screen, the last line of a view is shown again at
  the top of the next one, so your eyes find their place; with one or two
  lines the next view starts with the next line.
- *Across pages:* the end of one page and the beginning of the next can be on
  the screen together, so there is no hurried page turn in the middle of a
  phrase. A thin line marks where the next page begins. The page counter shows
  the page of the top line.
- *Title pages, text pages* and pages the system view is unsure about are
  shown as a whole page within the sequence.
- *Markings* work exactly as on whole pages: what you draw in the system view
  appears on the page, and the other way round. A line drawn across several
  lines of music stays one straight line (it ends at the bottom of a page).
- Your choice (pages or systems, and the size) is remembered for your account,
  also on your other devices.

#tip[A sheet uploaded a moment ago may still be analysed: the reader then
shows whole pages and says so. After a few seconds the system view is
available.]

== Your markings <member-markings>

Tap #ui("✎ Draw") to start writing into the music. A toolbar appears; tap
#ui("✓ Done") when you are finished, so that taps turn pages again.

#shot("reader-draw.png", [Drawing mode: a circle around a bar, a highlighted line, a hairpin, a "glasses" stamp and a text note.], width: 62%)

#table(
  columns: (auto, 1fr),
  [Tool], [Use],
  [#ui("Pen")], [Writes freehand. With a stylus, the line gets thicker the harder you press. Choose the colour (red, blue, black, green) and the width (fine, medium, bold) next to it.],
  [#ui("Highlighter")], [Transparent marker in yellow, green or pink. It always stays _behind_ the pen marks.],
  [#ui("Eraser")], [Removes a whole marking with one touch, e.g. a complete stroke.],
  [#ui("Text")], [Tap where the text should start, type it, confirm.],
  [#ui("Stamp…")], [Common signs with one tap: breath mark, fermata, glasses ("watch the conductor"), sharp, flat, natural, accent, caesura. Choose the sign, then tap the spot.],
  [#ui("↶") #ui("↷")], [Undo and redo.],
)

#tip(title: [Writing with a stylus])[
  Once you have used a stylus, Musicus ignores your fingers while drawing,
  so you can rest your hand on the screen.
]

=== Saving happens by itself

Your markings are saved automatically, about a second after you stop
drawing, and whenever you turn the page or leave the reader. The status at
the right of the toolbar shows *Unsaved*, *Saving…* or *Saved*. Even if you
close the tab right after drawing, the last strokes are sent.

You can draw on two devices, e.g. on your tablet in rehearsal and on your
laptop at home. Musicus combines the changes; nothing is lost.

=== When the server restarts, updates or cannot be reached <member-outage>

A notice at the bottom of the screen tells you what is going on. Whatever it
says, the sheets you have open stay readable and you can keep turning pages.

- *Server is shutting down* (an update or a restart, usually announced by
  the admin): Musicus first stops taking new markings, then sends the ones
  you just drew to the server at once, so nothing is lost. Drawing pauses
  (the toolbar says *Drawing paused*) until the server is back.
- *Server is starting*: the server is coming back, sometimes with an update
  of its data that takes a moment. Drawing stays paused; the notice
  disappears by itself when it is ready.
- *Server not reachable* (for example the Wi-Fi dropped): you can keep
  drawing. Your markings stay in the open tab and are saved by themselves
  when the connection is back; the reader says *Annotations not saved yet
  are kept in this tab*. Keep the tab open until the status shows *Saved*;
  the browser warns you if you try to close it before.
- *Musicus has been updated*: a new version runs on the server. Musicus
  switches to it by itself, but never while a part is open in the reader:
  it waits until you leave the reader (and until nothing is being saved or
  typed). #ui("Reload now") switches at once.

In the rare case that the server refuses markings (for example because it
was updated meanwhile), the reader says *These annotations couldn't be
saved* and keeps them in the tab; tell the admin.

=== Privacy

Your markings are visible to *nobody but you*: not to other musicians, not
to the librarian, not to the admin.

== Annotation sets: different markings for different concerts

For one part you can keep several sets of markings, e.g. "Christmas Concert
2026" and "Summer Tour 2027". The first time you draw on a part, Musicus
creates a set for you, named after the programme you opened it from.

Tap #ui("☰") in the reader to manage your sets:

#shot("reader-sets.png", [The annotation sets of a part.], width: 62%)

#table(
  columns: (auto, 1fr),
  [Button], [What it does],
  [Select a set], [Shows that set's markings. *No annotations* shows the clean sheet.],
  [#ui("New set")], [Starts an empty set.],
  [#ui("Duplicate")], [Copies the selected set, e.g. to adapt last year's markings for this year's concert.],
  [#ui("Rename")], [Gives the set a new name.],
  [#ui("Make default")], [This set opens when you open the part from the library.],
  [#ui("Use for this programme")], [This set opens automatically whenever you open the part from this programme.],
  [#ui("Delete")], [Deletes the set with all its markings, after asking.],
)

=== When the librarian corrects a sheet <member-versions>

If the librarian replaces a part with a corrected file, your markings stay
on the version you drew them on. Musicus shows a note at the top and offers
#ui("Move them to the current version").

#shot("reader-version.png", [After a correction: the markings still belong to version 1.], width: 62%)

Moving works if the new version has the same number of pages. Check the
markings afterwards, in case notes moved on the page.

== Your account

Click your name in the navigation bar.

- *Change password:* enter the current and the new password. All your other
  devices are logged out for safety.
- *Logged-in devices:* shows where you are logged in. Click #ui("Log out")
  next to a device you don't use any more, e.g. a lost tablet.

- *About Musicus:* the link at the end of the page shows which version of
  Musicus runs, its licence and where its source code is. The login page has
  the same link, so you can look it up without logging in.

#shot("member-account.png", [Your account: password and devices.])

#shot("about.png", [About Musicus: the version that runs, licence and source code.], width: 62%)

== On a phone

Musicus also works on phones. The menu sits behind the #ui("☰") button at
the top right.

#shots(
  shot("phone-library.png", [The library on a phone.], width: 80%),
  shot("phone-menu.png", [The menu opened.], width: 80%),
)
