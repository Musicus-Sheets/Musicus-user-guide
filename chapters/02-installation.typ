#import "../template.typ": *

= Installing Musicus <installation>
#who("admin")

Musicus is one small server program. It stores everything in one data
folder: a database file and the uploaded sheets. Musicians only need a web
browser, nothing is installed on their devices.

You can install Musicus in two ways:

#table(
  columns: (auto, 1fr, 1fr),
  [], [With Docker (recommended)], [Directly on the computer],
  [Best for], [Servers, a Raspberry Pi, anyone who already uses Docker], [Trying Musicus on your own PC, or systems without Docker],
  [You need], [Docker with the Compose plugin, Git], [Rust, the Dioxus CLI, Git, curl],
  [HTTPS], [Built in: one setting, certificates are automatic], [Bring your own (e.g. Caddy) or certificate files],
  [Updates], [`git pull` and one command], [Rebuild and restart],
)

== What you need

- *A computer that is always on while you rehearse.* Musicus is light: a
  Raspberry Pi 4 or 5, an old laptop, or a small rented server (1 CPU,
  1 GB RAM) is enough. It uses about 11 MB of memory when idle.
- *Disk space* for your sheets: a printed-quality part is typically
  0.1–3 MB, a scan 2–10 MB.
- *A network the devices can reach.* At home or in the rehearsal room this is
  your Wi-Fi; for access from anywhere, a server on the internet.

#warning(title: [Phones and tablets need HTTPS])[
  Browsers only keep you logged in and keep the screen on for websites with
  an encrypted connection (HTTPS). On the computer that runs Musicus,
  `http://localhost` works without it. For every other device, set up HTTPS
  as described below (@https).
]

== Install with Docker <docker>

=== 1. Get Musicus

```sh
git clone https://github.com/NelDav/Musicus.git
cd Musicus
```

=== 2. Adjust the settings (optional)

All settings live in a small text file called `.env`. Copy the example and
open it in any text editor:

```sh
cp .env.example .env
```

The defaults work for a first try. The most important settings:

#table(
  columns: (auto, 1fr),
  [Setting], [Meaning],
  [`MUSICUS_PUBLIC_URL`], [The address people type into their browser, e.g. `https://sheets.example.org`. Used in invite links.],
  [`MUSICUS_PORT`], [The port on this computer (default `8080`).],
  [`MUSICUS_DOMAIN`], [Your domain name, only for the HTTPS setup below.],
  [`MUSICUS_MAX_UPLOAD_MB`], [Largest sheet file you can upload (default 200 MB).],
  [`MUSICUS_SESSION_DAYS`], [How long a device stays logged in without use (default 60 days).],
)

=== 3. Start Musicus

```sh
docker compose up -d --build
```

The first start takes a while (10 to 30 minutes, longer on a Raspberry Pi),
because Docker builds Musicus from its source code. Later starts take
seconds.

=== 4. Open the admin link

On its very first start, Musicus creates the account `admin` and prints a
one-time link for setting its password:

```sh
docker compose logs musicus
```

```
WARN musicus_server: No users yet. Created 'admin'; set its password at:
WARN musicus_server: http://localhost:8080/invite/3f9c…
```

Open this link in your browser and continue with @admin-first-login.

#tip[
  There is no default password. Until somebody opens this link, nobody can
  log in, so it is safe to start Musicus before you are ready to set it up.
]

== Install directly on your computer <direct>

This way works on Linux and macOS. On Windows, use Docker Desktop and follow
@docker instead.

=== 1. Install the tools

+ Install Rust from #link("https://rustup.rs")[rustup.rs], then add the
  WebAssembly target that the web interface needs:
  ```sh
  rustup target add wasm32-unknown-unknown
  ```
+ Install the Dioxus CLI in exactly this version:
  ```sh
  cargo install dioxus-cli --version 0.7.10 --locked
  ```
+ Make sure `git`, `curl`, `openssl` and `tar` are available (they usually are).

=== 2. Build Musicus

```sh
git clone https://github.com/NelDav/Musicus.git
cd Musicus
./scripts/fetch-pdfjs.sh                                   # page display component
dx bundle --platform web --package musicus-web --release   # web interface
cargo build --release -p musicus-server                    # server
```

=== 3. Start it

```sh
./target/release/musicus-server serve \
    --data-dir ./data \
    --web-dir target/dx/musicus-web/release/web/public \
    --public-url http://localhost:8080
```

The admin link appears in the output. Open it in your browser on the same
computer and continue with @admin-first-login. Stop the server with
#kbd("Ctrl") + #kbd("C").

=== 4. Run it permanently (Linux)

To start Musicus automatically with the computer, copy the program and the
web interface to a fixed place and register a system service:

```sh
sudo useradd --system --home /var/lib/musicus musicus
sudo mkdir -p /opt/musicus /var/lib/musicus
sudo cp target/release/musicus-server /opt/musicus/
sudo cp -r target/dx/musicus-web/release/web/public /opt/musicus/web
sudo chown musicus /var/lib/musicus
```

Create `/etc/systemd/system/musicus.service`:

```ini
[Unit]
Description=Musicus sheet music server
After=network.target

[Service]
User=musicus
ExecStart=/opt/musicus/musicus-server serve
Environment=MUSICUS_DATA_DIR=/var/lib/musicus
Environment=MUSICUS_WEB_DIR=/opt/musicus/web
Environment=MUSICUS_LISTEN=127.0.0.1:8080
Environment=MUSICUS_PUBLIC_URL=https://sheets.example.org
Environment=MUSICUS_TRUST_PROXY=true
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```sh
sudo systemctl enable --now musicus
journalctl -u musicus | grep invite      # the admin link
```

This service listens only on the computer itself; put HTTPS in front of it
as described next.

== HTTPS for all devices <https>

You need a *domain name* (e.g. `sheets.example.org`) that points to the
computer running Musicus, and ports 80 and 443 must be reachable from the
internet so that the free certificate from Let's Encrypt can be issued.

*With Docker:* set these lines in `.env`:

```sh
MUSICUS_DOMAIN=sheets.example.org
MUSICUS_PUBLIC_URL=https://sheets.example.org
MUSICUS_BIND=127.0.0.1
MUSICUS_TRUST_PROXY=true
```

and start with the HTTPS profile, which adds the web server Caddy:

```sh
docker compose --profile https up -d --build
```

*Without Docker:* install #link("https://caddyserver.com")[Caddy] and use
this two-line configuration (`/etc/caddy/Caddyfile`):

```
sheets.example.org {
    reverse_proxy 127.0.0.1:8080
}
```

Alternatively, Musicus can use certificate files directly:
`--tls-cert fullchain.pem --tls-key privkey.pem`.

#note(title: [Raspberry Pi in a rehearsal room without internet])[
  Browsers do not accept self-made certificates. Use a real domain whose
  address points to the Pi in your local network and a certificate obtained
  through the DNS method of Let's Encrypt, or run Musicus on a rented server
  instead, which also works at concert venues and at home.
]

#warning(title: [Only for a quick test over the local network])[
  Starting Musicus with `MUSICUS_INSECURE_COOKIES=true` lets tablets log in
  over plain HTTP. Passwords then travel unencrypted, so never use this for
  real use.
]

== Backups <backups>

Back up two things, *in this order*: the database, then the folder `blobs`
with the sheet files. Both can be copied while Musicus runs. The `backup`
command only copies the database; it never changes it, whichever version of
Musicus wrote it.

*With Docker:*

```sh
docker compose exec musicus musicus-server backup --to /data/backup-2026-11-15.sqlite
docker run --rm -v musicus_musicus-data:/data -v "$PWD":/backup alpine \
    tar czf /backup/musicus-2026-11-15.tgz -C /data backup-2026-11-15.sqlite blobs
```

*Directly installed:*

```sh
musicus-server backup --data-dir /var/lib/musicus --to /backups/musicus-2026-11-15.sqlite
rsync -a /var/lib/musicus/blobs/ /backups/blobs/
```

#tip[
  Sheet files never change after upload, so tools like `rsync` or `restic`
  only copy new files and backups stay fast.
]

#warning(title: [Keep backups as safe as the server])[
  Backups, the snapshots in the folder `snapshots` and the data folder itself
  are not encrypted. They contain all sheets, every musician's markings, all
  user names and the password hashes. Store them where only administrators
  can read them, for example on an encrypted disk, and never in a shared or
  public folder.
]

=== Restoring a backup <restore>

Musicus must be stopped while you restore. The `restore` command checks that
the file is a Musicus database, keeps the current database in the folder
`snapshots` (as `replaced-<date and time>.sqlite`) and puts the backup in its
place. The folder `blobs` is not changed: if you lost it too, copy it back
from the same backup first (existing files there are never overwritten).

*With Docker:* the backup file must be inside the data volume (for example
`/data/backup-2026-11-15.sqlite`) or mounted into the container.

```sh
docker compose stop musicus
docker compose run --rm musicus restore --from /data/backup-2026-11-15.sqlite
docker compose up -d
```

*Directly installed:*

```sh
sudo systemctl stop musicus
sudo -u musicus /opt/musicus/musicus-server restore --data-dir /var/lib/musicus \
    --from /backups/musicus-2026-11-15.sqlite
sudo systemctl start musicus
```

If Musicus is still running, the command refuses and changes nothing. When
Musicus starts again it brings a backup of an older version up to date by
itself. A backup made by a *newer* version can be restored too, but an older
Musicus starts on it only if that version is close enough; otherwise it stops
with a message that names the version to start.

You can also restore one of the snapshots described below: pass its file,
for example `--from /data/snapshots/20261122T143000Z-1.0.0-to-1.1.0.sqlite`.

== Updating <updating>

```sh
git pull
docker compose up -d --build        # with Docker
```

Without Docker, repeat the build steps from @direct and restart the service.
Make a backup before every update (@backups).

Musicus updates its database automatically when it starts. Just before, it
saves a copy of the database, a *snapshot*, in the folder `snapshots` of the
data folder, named after the date and time (in UTC) and the two versions,
for example `20261122T143000Z-1.0.0-to-1.1.0.sqlite`. It keeps the three
newest snapshots and deletes older ones. Snapshots need about as much space
as the database (the sheet files are not copied); if the disk is too full,
Musicus does not update and says how much space it needs.

=== If an update fails <failed-update>

If a database update fails, Musicus puts the snapshot back by itself, so
your data is exactly as before the update, and stops. The log
(`docker compose logs musicus`, or `journalctl -u musicus`) then ends with a
message like this:

```
The database update 1.1.0 failed in its additive part and was rolled back: …
The database was put back from the snapshot snapshots/20261122T143000Z-1.0.0-to-1.1.0.sqlite
taken just before, so the data is unchanged (the failed state is kept as
snapshots/failed-20261122T143000Z.sqlite for diagnosis). What to do: start the
release that ran before, Musicus 1.0.0, again …
```

What to do:

+ Go back to the version named in the message: with Docker, check out that
  version again (`git checkout v1.0.0`) and run
  `docker compose up -d --build`; without Docker, install that version's
  program again. Musicus works as before.
+ Report the problem with the complete message (the link is in the
  message). The file `failed-….sqlite` helps to find the cause, but it
  contains your data: share it only with someone you trust.
+ Wait for a fixed version and update to it as usual.

The failed version does not try again by itself, even when Docker restarts
it again and again: it stops at once with a message that says so. To let the
same version try once more (for example after freeing disk space), run:

```sh
docker compose run --rm musicus retry-update        # with Docker
musicus-server retry-update --data-dir /var/lib/musicus   # directly installed
```

The folder `snapshots` may also hold `failed-…` and `replaced-…` files from
failed updates and restores. Musicus never deletes them; delete them yourself
when you no longer need them.

To see which version runs, open #ui("About Musicus") (on the login page or at
the end of your account page), or run `musicus-server --version`. Use the user
guide of that version; its title page names the version it describes.

== All settings

Every setting can be given in `.env` (Docker), as an environment variable,
or as an option of `musicus-server serve` (e.g. `--max-upload-mb 300`).

#table(
  columns: (auto, auto, 1fr),
  [Environment variable], [Default], [Meaning],
  [`MUSICUS_DATA_DIR`], [`data`], [Folder for the database and the sheet files],
  [`MUSICUS_LISTEN`], [`0.0.0.0:8080`], [Address and port the server listens on],
  [`MUSICUS_WEB_DIR`], [–], [Folder of the web interface (set in Docker)],
  [`MUSICUS_PUBLIC_URL`], [`http://localhost:8080`], [Address used in invite links],
  [`MUSICUS_TLS_CERT`, `MUSICUS_TLS_KEY`], [–], [Certificate files for HTTPS without Caddy],
  [`MUSICUS_CLIENT_CACHE`], [`none`], [`none`: browsers keep no copies of sheets. `immutable`: browsers may keep copies (faster reloads)],
  [`MUSICUS_RAM_CACHE_MB`], [`128`], [Memory for keeping often-used sheets ready],
  [`MUSICUS_MAX_UPLOAD_MB`], [`200`], [Largest upload],
  [`MUSICUS_SESSION_DAYS`], [`60`], [Days a device stays logged in without use],
  [`MUSICUS_TRUST_PROXY`], [`false`], [Set to `true` behind Caddy or another proxy],
  [`MUSICUS_INSECURE_COOKIES`], [`false`], [Tests over plain HTTP only],
  [`RUST_LOG`], [`info`], [Amount of log output],
)
