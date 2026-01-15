# О проекте

CRM — это единый backend + frontend, использующий модульную архитектуру.

Backend: Node.js (@crm/core)
Frontend: React
БД: PostgreSQL
Миграции: SQL-first (dbmate)

## Структура

```
core/          # backend API (единственный сервер)
db/
  migrations/  # история изменений схемы
  schema.sql   # полный слепок схемы БД (read-only)
```

## Как запускать backend локально

```
cd core
pnpm install
pnpm run start
```

Backend будет доступен на:

```
http://127.0.0.1:3000
```

## Переменные окружения

```
DATABASE_URL=postgres://crm_app:***@localhost:5432/crm
PORT=3000
NODE_ENV=development
```

## Миграции БД

Миграции запускаются вручную:

```
dbmate up
```

Backend не выполняет миграции автоматически.

## Архитектурные принципы

- Один backend — один API
- Домены подключаются явно
- База данных — источник истины
- Минимум магии, максимум прозрачности

## Партнёрский API

Партнёрский API находится по базовому пути:

```
/api/partners/v1
```

Он работает в том же backend, использует отдельную авторизацию и не дублирует сервисы.
