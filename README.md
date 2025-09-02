# DO → Local PostgreSQL Backup & Restore

Open-source scripts and Docker setup to **back up a DigitalOcean Managed Postgres** database and **restore locally** for testing/dev/DR.

> ✅ Includes `public` pre-data (types/extensions) + full `logistics` schema, and restore flags to avoid owner/privilege noise.

## Features
- Nightly backup shell script (`scripts/pg_backup_do.sh`)
- Local Postgres via Docker Compose (default host port **5433**)
- One-command restore (`scripts/restore.sh`)
- Examples for `~/.pgpass` and `.env`
- MIT-licensed, CI linting (shellcheck)

## Quickstart
```bash
git clone https://github.com/you/do-pg-backup-restore.git
cd do-pg-backup-restore

# 1) Start local Postgres
docker compose up -d

# 2) Configure env
cp .env.example .env
# edit .env and examples/.pgpass.example, then:
chmod 600 examples/.pgpass.example

# 3) Run a test backup (from your machine with DO access)
bash scripts/pg_backup_do.sh

# 4) Restore locally
bash scripts/restore.sh
```

## Repository layout
```
.
├─ docker-compose.yml
├─ scripts/
│  ├─ pg_backup_do.sh       # creates a restore-friendly .dump
│  └─ restore.sh            # restores into local DB (port 5433)
├─ examples/
│  └─ .pgpass.example       # sample entries for pg client auth
├─ docs/
│  ├─ TROUBLESHOOTING.md
│  └─ SECURITY.md
├─ .github/workflows/shellcheck.yml
├─ .gitignore
├─ .env.example
├─ LICENSE
└─ README.md
```

## Backups include
- `public` schema **pre-data only** (extensions, enums/types needed by app)
- `logistics` schema **pre-data, data, post-data**

## Why not dump everything?
- DigitalOcean managed roles & RLS/ACLs can cause noisy restores.
- This project targets **developer-friendly restores** on local Docker while retaining the data shape.

## Contributing
PRs & issues welcome! See [CONTRIBUTING](CONTRIBUTING.md) or open an issue with details.

## License
[MIT](LICENSE)
