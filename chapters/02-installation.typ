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

== Backups

Back up two things, *in this order*: the database, then the folder `blobs`
with the sheet files. Both can be copied while Musicus runs.

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

*To restore,* stop Musicus, delete `musicus.sqlite-wal` and
`musicus.sqlite-shm` in the data folder if they exist, put the backup file
there as `musicus.sqlite` (next to `blobs`), and start Musicus again.

#tip[
  Sheet files never change after upload, so tools like `rsync` or `restic`
  only copy new files and backups stay fast.
]

== Updating

```sh
git pull
docker compose up -d --build        # with Docker
```

Without Docker, repeat the build steps from @direct and restart the service.
Musicus updates its database automatically when it starts. Make a backup
before every update.

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
