# Contributing Guide

First off, thank you for considering contributing! 🎉  
This project aims to make **DigitalOcean → local PostgreSQL backups** easy and reliable. Contributions of all kinds are welcome — from bug reports to code patches, docs improvements, and feature suggestions.

---

## How to Contribute

### 1. Fork & Clone
```bash
git clone https://github.com/<your-username>/do-pg-backup-restore.git
cd do-pg-backup-restore
```

### 2. Branch

Create a feature branch:
```bash
git checkout -b feature/my-new-feature
```

### 3. Make Changes

- Update scripts in `scripts/`
- Add documentation in `docs/`
- Adjust configs (`.env.example`, `docker-compose.yml`, etc.)
- Keep credentials out of git (`.env` and dumps are already in `.gitignore`).

### 4. Test

- Run bash `scripts/pg_backup_do.sh` against your DO DB (with sanitized creds).
- Restore locally:
    ```bash
    bash scripts/restore.sh
    ```
- Verify data exists:
    ```bash
    psql -h localhost -p 5433 -U myuser -d logistics_restore -c "\dt logistics.*"
    ```

### 5. Lint

We use shellcheck in CI:

    ```bash
    shellcheck scripts/*.sh
    ```

### 6. Commit & Push

```bash
git commit -m "Add feature: description"
git push origin feature/my-new-feature
```

### 7. Pull Request

Open a PR against `main`. Please describe:

- What you changed
- Why (link issues if relevant)
- How you tested

## Contribution Guidelines

- Follow existing script style (`set -euo pipefail`, comments, logging).
- Prefer portable shell (bash) over complex dependencies.
- Document new environment variables in `.env.example` and `README.md`.
- Keep PRs focused (one feature/fix per PR).
- Avoid committing secrets, dumps, or logs.

## Reporting Issues

Use GitHub Issues and include:

- OS & PostgreSQL version
- DigitalOcean DB version
- Steps to reproduce
- Expected vs actual behavior

## Code of Conduct

Please be respectful and constructive.
This project follows the [Contributor Covenant](https://www.contributor-covenant.org/).

## License

By contributing, you agree your contributions will be licensed under the MIT License.