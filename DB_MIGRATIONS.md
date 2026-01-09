# PostgreSQL schema migrations

This project uses **SQL-first, file-based migrations** to version the PostgreSQL schema.
Migrations exist solely to track and apply schema evolution; they are **never imported,
executed, or referenced by application runtime code**.

There is **no ORM, no auto-sync, and no schema management logic** in the backend.
PostgreSQL remains the single source of truth.

---

## Goals and non-goals

### Goals
- Deterministic, auditable schema evolution
- Plain SQL without abstraction layers
- Safe concurrent execution and locking
- Compatibility with CI/CD and manual execution

### Non-goals
- Runtime schema synchronization
- ORM-managed migrations
- Automatic schema changes on application startup
- Data backfills or business logic in migrations

---

## Directory layout

db/
├─ migrations/ # ordered SQL migration files (dbmate format)
│ ├─ 001_init.sql
│ ├─ 002_feature.sql
│ └─ 003_fix_index.sql
└─ README.md # this document

- `db/` is **not part of the runtime artifact**
- Migration files must **never** be imported by backend code
- The only supported executor is `dbmate`

---

## Baseline (001_init.sql)

`001_init.sql` represents the **baseline schema**.

It is an exact snapshot of the current production schema obtained via:

```bash
pg_dump --schema-only --no-owner --no-privileges crm > schema.sql
Notes:
SET search_path statements were removed
Fully qualified object names are preferred
This file is the zero point of schema history
Rules:
001_init.sql must never be edited
Rollback is intentionally omitted
All subsequent changes must be expressed as new migrations
Migration file format (dbmate contract)
Although migrations are SQL-first, they must follow the dbmate file contract.
Each migration file must define an explicit up block:

-- migrate:up
An optional rollback can be defined using:
-- migrate:down
Only SQL statements inside the -- migrate:up block are executed when running migrations.
Anything outside these blocks is ignored.
Example
-- migrate:up

ALTER TABLE core.users
  ADD COLUMN locale text;

-- migrate:down

ALTER TABLE core.users
  DROP COLUMN locale;
Authoring migrations
Choose the next sequential prefix:
002_feature.sql
003_fix_index.sql
Write schema-only SQL inside a -- migrate:up block.
One migration = one logical schema change.
Never modify, rewrite, or reorder existing migrations.
Append new files only.
Avoid SET search_path. Use fully qualified names if required.
Do not include:
application logic
data backfills unrelated to schema management
procedural control flow outside SQL DDL
Execution policy
No auto-migrate
No auto-sync
No schema changes from application code
Migrations are executed:
manually by developers
or by CI/CD pipelines
Migrations are never executed on backend startup
dbmate is used solely as:
a migration executor
a concurrency lock manager
a schema_migrations tracker
It does not introduce a runtime abstraction layer.
Running migrations
Prerequisites
PostgreSQL
dbmate installed locally or in CI
Configuration
Set the database connection string:
export DATABASE_URL="postgres://user:password@host:5432/crm?sslmode=disable"
Apply migrations
dbmate -d db/migrations up
Check migration status
dbmate -d db/migrations status
Production usage
In production environments:
Migrations are executed from the deployment pipeline
They must complete successfully before application rollout
The same migration set is used for all environments
Manual execution on production databases outside CI/CD is discouraged.
Invariants (must not be violated)
dbmate is the only supported migration runner
Raw execution of migration files via psql is forbidden
Applied migrations are immutable
The backend must never create, alter, or sync schema objects
PostgreSQL schema state defines truth; migrations document its evolution
Violating these rules breaks determinism and auditability.
Summary
SQL-first, append-only migrations
Deterministic execution via dbmate
No runtime schema management
PostgreSQL remains authoritative
If the schema changes, a migration file must exist.
If a migration file exists, it must be executable by dbmate.