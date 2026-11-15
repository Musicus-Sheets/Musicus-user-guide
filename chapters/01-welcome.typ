#import "../template.typ": *

= Welcome to Musicus <welcome>

Musicus brings your ensemble's sheet music to tablets, laptops and phones.
The librarian uploads the parts once; every musician automatically sees
exactly the parts they play, can turn pages with a tap or a foot pedal, and
can write their own markings into the music, just like with a pencil, but
without ever changing the original sheet.

#cards(
  path-card([I run the server], [Start with @installation, then @admin.], color: role-colors.admin),
  path-card([I look after the music], [Go to @librarian.], color: role-colors.librarian),
  path-card([I play in the ensemble], [Jump to @member. It takes five minutes.], color: role-colors.member),
)

== Three roles

Everybody who uses Musicus has an account with one of three roles. The role
decides what you may *manage*; which sheets you may *read* is decided by your
groups (see below).

#table(
  columns: (auto, 1fr),
  [Role], [What this person does],
  [#role("member")], [Plays in the ensemble. Reads the parts that are shared with them, marks them up with private annotations, uses concert programmes.],
  [#role("librarian")], [Everything a member can do, plus: maintains the library (works, parts, PDF files), the list of instruments, concert programmes, and which group may read which music.],
  [#role("admin")], [Everything a librarian can do, plus: creates user accounts, assigns roles, manages groups and their members, and runs the server.],
)

#note[
  In this guide the ensemble's musicians are called *members*, the name
  Musicus uses on screen. An ensemble usually has one or two admins, a few
  librarians, and everybody else is a member.
]

== How musicians get their music

Musicus never shares single files with single people. Instead:

+ Every *part* (one PDF, e.g. "2nd Trumpet in Bb") is tagged with the
  *instrument* it is for.
+ Musicians belong to *groups*, for example "Trumpets" or "Flutes".
+ A group is allowed to read one or more instruments: the group "Trumpets"
  reads every part tagged "Trumpet".

So when a new piece arrives, the librarian only uploads its parts and tags
them. Every trumpet player sees the trumpet parts at once, without anybody
assigning files. For the conductor, a group can also be given *whole scores*,
so it sees every part of a work.

#tip[
  When someone cannot see a part they need, the answer is almost always: they
  are not in the right group, or the part is not tagged with the right
  instrument. @faq explains how to check.
]

== Your markings stay yours

Annotations are private. Nobody else, not even the admin, can see what you
draw. You can keep several *annotation sets* per part, e.g. one for the
Christmas concert and one for the summer tour, and switch between them.
Your markings are saved on the server, so they are there again on your next
visit, on any device.
