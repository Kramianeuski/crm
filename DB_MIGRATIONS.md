# Database migrations

This project uses SQL-first migrations to version the PostgreSQL schema without introducing any runtime automation or ORM coupling.

## Layout
- `db/migrations/` — ordered SQL migrations applied manually or by CI/CD tooling.
- `db/migrations/001_init.sql` — snapshot of the current database schema produced via `pg_dump --schema-only` and never edited after commit.

## Ground rules
- PostgreSQL remains the single source of truth; backend code talks directly to it.
- Migrations are **SQL-only** and are **not** imported or executed by the application at runtime.
- No auto-migrate/auto-sync/db push flows; migrations run only manually or in CI/CD.
- Each schema change lives in a new, incrementally numbered file (e.g., `002_add_indexes.sql`, `003_alter_users.sql`).
- Do not modify or delete existing migration files; append new ones for future changes.

## Applying migrations
1. Connect with a privileged PostgreSQL role and create the version table once if it does not exist:
   ```sql
   CREATE TABLE IF NOT EXISTS schema_migrations (version text PRIMARY KEY);
   ```
2. Apply migrations in numeric order using `psql` (or a SQL-first runner that writes to `schema_migrations`):
   ```bash
   psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/migrations/001_init.sql
   # future migrations:
   # psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/migrations/002_add_indexes.sql
   ```
3. Record applied versions:
   ```sql
   INSERT INTO schema_migrations (version) VALUES ('001_init') ON CONFLICT DO NOTHING;
   -- repeat per migration file
   ```

### Environment guidance
- Dev: run the migrations manually before starting backend services.
- Stage/Prod: run the same SQL files in order via your deployment pipeline; avoid running migrations concurrently (use locking/version table from your runner).

## Adding new migrations
1. Generate the required DDL as SQL, save it to a new numbered file under `db/migrations/`.
2. Keep files self-contained; avoid dependencies on application code or environment-specific helpers.
3. Update operational runbooks or CI steps to apply the new file in order.

## Definition of done
- `db/migrations/001_init.sql` reproduces the current schema and is immutable.
- Backend works without code changes after migrations run.
- Migrations are versioned in git and kept out of runtime execution paths.
