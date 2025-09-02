#!/usr/bin/env bash
set -euo pipefail

# Load env if present
if [ -f ".env" ]; then
  set -a
  . ./.env
  set +a
fi

# === CONFIG ===
HOST="${DO_HOST:?DO_HOST not set}"
PORT="${DO_PORT:-25060}"
DB="${DO_DB:-logistics_db}"
USER="${DO_USER:-backup_user}"
CA="${DO_CA:?DO_CA not set}"
OUTDIR="${BACKUP_OUTDIR:?BACKUP_OUTDIR not set}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"

# Prefer ~/.pgpass, else DO_PASS must be set
PASS="${DO_PASS:-}"

mkdir -p "$OUTDIR"
ts="$(date +%F)"
dump_file="$OUTDIR/${DB}_${ts}.dump"

echo "[$(date '+%F %T')] Starting backup for $DB"

# === MAIN DUMP ===
# Include public pre-data (types/extensions) and full logistics schema
if [ -n "$PASS" ]; then
  PGPASSWORD="$PASS" PGSSLMODE=require PGSSLROOTCERT="$CA"   pg_dump     --host="$HOST" --port="$PORT"     --username="$USER" --dbname="$DB"     --format=custom --no-owner --no-privileges --blobs -Z0     --schema=public   --section=pre-data     --schema=logistics --section=pre-data     --schema=logistics --section=data     --schema=logistics --section=post-data     -f "$dump_file"
else
  PGSSLMODE=require PGSSLROOTCERT="$CA"   pg_dump     --host="$HOST" --port="$PORT"     --username="$USER" --dbname="$DB"     --format=custom --no-owner --no-privileges --blobs -Z0     --schema=public   --section=pre-data     --schema=logistics --section=pre-data     --schema=logistics --section=data     --schema=logistics --section=post-data     -f "$dump_file"
fi

# === Verify dump has DATA entries
if ! pg_restore -l "$dump_file" | grep -q 'TABLE DATA'; then
  echo "[WARN] No TABLE DATA entries found in $dump_file"
  exit 1
fi
echo "[OK] Data sections present in $dump_file"

# === CLEANUP OLD FILES ===
find "$OUTDIR" -type f -mtime +"$RETENTION_DAYS" -delete
echo "[$(date '+%F %T')] Backup complete: $dump_file"
