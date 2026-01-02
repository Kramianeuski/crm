# PostgreSQL schema migrations

This project uses **SQL-first** migrations to version the PostgreSQL schema without adding any runtime layer. Migrations exist solely to track schema compatibility with the backend; they are never imported or executed by the application code.

## Layout
- `db/migrations/`: ordered `.sql` migrations.
- `db/` is not part of the runtime. Do not import it from the backend or bundle it with application artifacts.

## Current baseline
- `001_init.sql` is the exact snapshot of the current production schema obtained via `pg_dump --schema-only --no-owner --no-privileges crm > schema.sql` (search path statements removed). It represents the zero point and must never be edited.

## Authoring migrations
1. Choose the next sequential prefix (e.g., `002_feature.sql`, `003_fix_index.sql`).
2. Write **SQL-only** statements that apply the intended schema change. Do not mix multiple logical changes in one migration.
3. Never modify or rewrite existing migration files. Append new ones only.
4. Avoid `SET search_path` statements. Prefer fully qualified names if needed.
5. Migrations must not perform data writes unrelated to schema management.

## Execution policy
- No auto-migrate, no auto-sync, and no schema changes from application code.
- Migrations are run manually by developers or in CI/CD pipelines. They are **not** executed at backend start.
- PostgreSQL remains the single source of truth; migrations simply document its evolution.

## Running migrations
A SQL-first tool such as [`dbmate`](https://github.com/amacneil/dbmate) is recommended because it creates a `schema_migrations` table, locks concurrent runs, and executes files in order.

1. Install `dbmate` locally or in CI.
2. Set `DATABASE_URL` to the target database, e.g. `postgres://user:password@host:5432/crm?sslmode=disable`.
3. Run migrations: `dbmate -d db/migrations up`.
4. Check status: `dbmate -d db/migrations status`.

For production, run the same commands from your deployment pipeline before rolling out code changes. For development, run them manually after pulling new migrations.

## Key principle
Migrations control how the PostgreSQL schema changes over time; they do **not** introduce an abstraction layer between the backend and the database.
