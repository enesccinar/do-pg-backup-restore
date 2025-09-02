# Troubleshooting

## Common issues

### `FATAL: password authentication failed`
- Ensure you're using a **database user** (e.g., `backup_user`, not a system username).
- Prefer `~/.pgpass` with `chmod 600`.

### `pg_hba.conf rejects connection` to `template1`
- DigitalOcean blocks non-admin access to `template1`.
- If you run `pg_dumpall --globals-only`, connect to `defaultdb` instead, or skip globals entirely.

### `parallel restore from standard input is not supported`
- Don’t pipe compressed streams to `pg_restore -j`.
- Use a `.dump` file or directory format.

### `type "public.*" does not exist`
- Include `--schema=public --section=pre-data` in the dump to capture enums/extensions.

### `role "doadmin" does not exist` (or other roles)
- Restore with `--no-owner --no-privileges --role=<localuser>`.
