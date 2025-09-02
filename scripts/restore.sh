#!/usr/bin/env bash
set -euo pipefail

# Load env if present
if [ -f ".env" ]; then
  set -a
  . ./.env
  set +a
fi

DUMP="${1:-${BACKUP_OUTDIR:-}/logistics_db_$(date +%F).dump}"
HOST="${LOCAL_PGHOST:-localhost}"
PORT="${LOCAL_PGPORT:-5433}"
USER="${LOCAL_PGUSER:-myuser}"
DB="${LOCAL_RESTORE_DB:-logistics_restore}"

echo "Restoring $DUMP -> $USER@$HOST:$PORT/$DB"

# fresh db
psql -h "$HOST" -p "$PORT" -U "$USER" -d postgres -c "DROP DATABASE IF EXISTS $DB;"
psql -h "$HOST" -p "$PORT" -U "$USER" -d postgres -c "CREATE DATABASE $DB OWNER $USER;"

# Optional: filter out CREATE SCHEMA public noise
TOC="$(mktemp)"
pg_restore -l "$DUMP" > "$TOC"
sed -i.bak '/SCHEMA - public$/d;/COMMENT - SCHEMA public$/d' "$TOC" || true

pg_restore -h "$HOST" -p "$PORT" -U "$USER"   --no-owner --no-privileges --role="$USER"   -d "$DB" -j 4 -L "$TOC" "$DUMP"

# quick checks
psql -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -c "\dt logistics.*" || true
psql -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -c "SELECT COUNT(*) FROM logistics.app_user;" || true

echo "✅ Restore complete into $DB"
