#!/usr/bin/env bash
set -euo pipefail

# ================================
# Resolve project root
# ================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ================================
# Configuration
# ================================
OUTPUT_FILE="${PROJECT_ROOT}/db/schema.sql"

# ================================
# Preconditions
# ================================
if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "❌ DATABASE_URL is not set"
  echo "   Example:"
  echo "   export DATABASE_URL=postgres://user:pass@host:5432/dbname"
  exit 1
fi

echo "📦 Generating schema dump from DATABASE_URL"

# ================================
# Dump schema and clean it
# ================================
pg_dump \
  --schema-only \
  --no-owner \
  --no-privileges \
  "${DATABASE_URL}" \
| awk '
  # Drop psql meta-commands
  /^[[:space:]]*\\restrict/ { next }
  /^[[:space:]]*\\unrestrict/ { next }

  # Drop session-level SET statements
  /^[[:space:]]*SET[[:space:]]/ { next }
  /^SELECT pg_catalog.set_config/ { next }

  # Drop dbmate internal table completely
  /schema_migrations/ { next }

  { print }
' > "${OUTPUT_FILE}"

echo "✅ Schema written to ${OUTPUT_FILE}"
echo "ℹ️  This file is READ-ONLY reference and must not be executed."
