# Database rules and contracts

## 1. Общее правило миграций

SQL-first. Миграции — единственный источник правды о схеме и справочных данных.

dbmate:

- каждый файл содержит `-- migrate:up` / `-- migrate:down`;
- миграция обязана быть идемпотентной (`ON CONFLICT`, `WHERE NOT EXISTS`);
- повторный `dbmate up` не должен ломать БД.

Никаких догадок по схеме. Перед написанием миграции:

- смотреть предыдущие миграции;
- смотреть `\d table_name` в реальной БД.

## 2. Правило i18n (КРИТИЧЕСКОЕ)

Модель i18n в проекте:

- `core.i18n_keys(key TEXT PRIMARY KEY)`
- `core.i18n_translations(key TEXT FK → i18n_keys.key, language_code, value)`
- `core.translations` — legacy, использовать только если явно требуется

Запрещено:

- ❌ вставлять в `core.i18n_translations`, если ключ не существует в `core.i18n_keys`;
- ❌ использовать несуществующие поля (`key_id`, `translation_id` и т.п.);
- ❌ смешивать новую i18n и legacy без причины.

Обязательный порядок:

1. СНАЧАЛА `INSERT INTO core.i18n_keys`
2. ПОТОМ `INSERT INTO core.i18n_translations`
3. `core.translations` — только временно и осознанно

Эталонный паттерн:

```sql
INSERT INTO core.i18n_keys (key)
VALUES ('some.key')
ON CONFLICT (key) DO NOTHING;

INSERT INTO core.i18n_translations (key, language_code, value)
VALUES ('some.key', 'ru', 'Значение')
ON CONFLICT (key, language_code) DO UPDATE
SET value = EXCLUDED.value;
```

## 3. Правило зависимостей

Справочники → настройки → данные. Пример:

1. permissions
2. roles
3. modules
4. pages
5. translations

Нельзя:

- ссылаться на запись, которая может не существовать;
- надеяться, что “она есть в проде”.

## 4. Правило settings_*

`core.settings_modules.title_key` и `core.settings_pages.title_key`:

- всегда должны существовать в `i18n_keys`;
- переводы добавляются в той же миграции.

UI не обязан иметь fallback — данные должны быть корректны в БД.

## 5. Правило правок миграций

- ❌ нельзя писать новую миграцию, не понимая предыдущую;
- ❌ нельзя “чинить на глаз”;
- ✅ сначала анализ схемы, потом SQL.

## 6. Что считается ошибкой разработчика

- использование полей, которых нет в схеме;
- FK-ошибки при `dbmate up`;
- нарушение порядка вставок;
- отсутствие идемпотентности;
- дублирование ключей i18n;
- смешивание legacy и новой логики без комментария.

## Базовая архитектурная база (зафиксировать и не возвращаться)

### Роли БД

- `crm_migrator` — владелец БД, все миграции только от него;
- `crm_app` — CRUD без DDL;
- никаких правок под postgres в проде.

### Модули

- Backend: модуль работает только если зарегистрирован в assembly;
- Frontend: модуль работает только если зарегистрирован в registry + i18n.

### Источник правды

- Схема БД → миграции;
- UI → читает данные, не “угадывает”.
