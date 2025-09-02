# Security Notes

- **Never commit secrets** (passwords, CA certs, tokens) to the repo.
- Use `~/.pgpass` for credentials (`chmod 600`).
- Restrict backup file access; consider volume encryption (FileVault/LUKS) or GPG.
- Limit the DO user to least privilege (read-only for backups).
- Rotate credentials periodically and after sharing artifacts/logs.
