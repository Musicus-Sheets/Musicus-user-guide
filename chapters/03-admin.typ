#import "../template.typ": *

= For admins <admin>
#who("admin")

As admin you create the accounts and decide who belongs to which group.
Everything a librarian can do is also open to you (@librarian).

== First login <admin-first-login>

Open the admin link from the server's output (@installation). Choose a
password with at least 8 characters, type it twice, and click
#ui("Set password and log in").

#shots(
  shot("admin-invite.png", [Choosing the admin password.]),
  shot("admin-empty-library.png", [Right after the first login, the library is still empty.]),
)

You land in the *Library*, which is empty for now. In the navigation bar at
the top you find #ui("Library"), #ui("Programmes") and #ui("Instruments")
like every musician, and in addition #ui("Groups") and #ui("Users"), then
your name (your account) and #ui("Log out").

There is no separate administration area. You see the same pages as the
musicians, with extra buttons such as #ui("+ Add piece") or #ui("Edit") where
something can be changed. Musicians see the same pages without these
buttons.

#tip(title: [Your first hour with Musicus])[
  + Add the instruments of your ensemble (@instruments).
  + Create the accounts (@users).
  + Create the groups and fill them (@groups).
  + Upload a first piece and give the groups access (@scores, @access).
  + Ask a musician to log in and check that they see their part.
]

== Creating accounts <users>

Musicus never asks you to invent passwords for other people. You create the
account, and the person chooses their own password through a personal
one-time link.

+ Click #ui("Users") in the navigation bar.
+ Under *New user*, enter a *username* (letters, digits, `.`, `_`, `-`; this
  is what the person types when logging in) and a *display name* (shown in
  lists, e.g. "Anna Berger").
+ Choose the role: #ui("Member"), #ui("Librarian") or #ui("Admin").
+ Click #ui("Create and get invite link").
+ A box with the link appears. Click #ui("Copy") and send the link to the
  person, by e-mail or any messenger. It is valid for 7 days.

#shot("users.png", [The user list with the invite link of a newly created account at the top.])

In the list, *Invited* means the person has not chosen a password yet;
*Active* means the account is in use.

#note[
  Usernames are not case-sensitive: "Anna" and "anna" are the same account.
]

== Managing accounts

All actions are in the user list (#ui("Users")):

#table(
  columns: (auto, 1fr),
  [To …], [do this],
  [change someone's role], [choose another role in the *Role* column. It applies immediately.],
  [help someone who forgot their password], [click #ui("Reset link") and send the new link. Their old password stops working once they use it, and they are logged out everywhere.],
  [send a lost or expired invite again], [click #ui("New invite link").],
  [block an account (e.g. someone left the ensemble)], [click #ui("Disable"). The person is logged out on all devices at once. Their markings are kept, and #ui("Enable") brings everything back.],
)

#warning[
  You cannot disable your own account or take away your own admin role, so
  the ensemble can never lock itself out. Keep at least two admins, in case
  one is unavailable.
]

== Groups <groups>

Groups bundle musicians who need the same music, e.g. "Trumpets", "Flutes"
or "Conductor". A musician can be in several groups, for example a
trumpeter who also plays flugelhorn.

+ Click #ui("Groups") in the navigation bar.
+ Type a name into *New group, e.g. Trumpets* and click #ui("Add").
+ Select the group in the list on the left.
+ Under *Members*, tick everybody who belongs to it.
+ Choose what the group may read (this part can also be done by librarians,
  see @access).
+ Click #ui("Save").

#shot("groups.png", [The group "Trumpets": two members, access to all trumpet parts.])

Changes take effect immediately: removed members lose access with their next
click, new members see the music right away.

== If you lose the admin password

If no admin can log in any more, create a new admin account on the server
itself:

```sh
docker compose exec musicus musicus-server create-admin --username admin2
# without Docker:
musicus-server create-admin --data-dir /var/lib/musicus --username admin2
```

The command prints a one-time link for the new account.
