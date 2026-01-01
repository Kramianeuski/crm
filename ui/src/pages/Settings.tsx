import { FormEvent, useContext, useEffect, useMemo, useState } from 'react';
import { AuthContext } from '../app/App';

type NavItem = {
  key: string;
  label: string;
  permission: string;
};

type Language = {
  code: string;
  name: string;
  enabled: boolean;
  isDefault?: boolean;
};

type UserRow = {
  email: string;
  firstName: string;
  lastName: string;
  company: string;
  status: 'active' | 'inactive';
  language: string;
  roles: string[];
  groups: string[];
  department: string;
};

type RoleRow = {
  code: string;
  name: string;
  scope: 'none' | 'own' | 'department' | 'all';
  permissions: string[];
};

type AccessPolicy = {
  id: string;
  description: string;
  appliesTo: string;
};

type AuditLog = {
  id: string;
  event: string;
  user?: string;
  entity?: string;
  payload: Record<string, unknown>;
  created_at: string;
};

const navItems: NavItem[] = [
  { key: 'system', label: 'System', permission: 'system.manage' },
  { key: 'users', label: 'Users', permission: 'users.manage' },
  { key: 'roles', label: 'Roles & Access', permission: 'roles.manage' },
  { key: 'languages', label: 'Languages', permission: 'languages.manage' },
  { key: 'audit', label: 'Audit Logs', permission: 'audit.view' }
];

const languages: Language[] = [
  { code: 'en', name: 'English', enabled: true, isDefault: true },
  { code: 'ru', name: 'Русский', enabled: true },
  { code: 'de', name: 'Deutsch', enabled: false }
];

const users: UserRow[] = [
  {
    email: 'ceo@example.com',
    firstName: 'Elena',
    lastName: 'Morozova',
    company: 'Timeweb',
    status: 'active',
    language: 'ru',
    roles: ['owner'],
    groups: ['executive'],
    department: 'Board'
  },
  {
    email: 'manager@example.com',
    firstName: 'Ivan',
    lastName: 'Petrov',
    company: 'Timeweb',
    status: 'active',
    language: 'en',
    roles: ['manager'],
    groups: ['sales'],
    department: 'Sales'
  },
  {
    email: 'contractor@example.com',
    firstName: 'Anna',
    lastName: 'Kuznetsova',
    company: 'Contractors Ltd',
    status: 'inactive',
    language: 'en',
    roles: ['viewer'],
    groups: ['partners'],
    department: 'Vendors'
  }
];

const roles: RoleRow[] = [
  {
    code: 'owner',
    name: 'Owner',
    scope: 'all',
    permissions: ['settings.view', 'system.manage', 'roles.manage', 'users.manage', 'languages.manage', 'audit.view']
  },
  {
    code: 'manager',
    name: 'Department manager',
    scope: 'department',
    permissions: ['settings.view', 'users.manage', 'audit.view']
  },
  {
    code: 'viewer',
    name: 'Read only',
    scope: 'own',
    permissions: ['settings.view', 'audit.view']
  }
];

const policies: AccessPolicy[] = [
  {
    id: 'policy-1',
    description: 'Менеджеры видят все сделки департамента, кроме контрагента X',
    appliesTo: 'sales'
  },
  {
    id: 'policy-2',
    description: 'Пользователи видят только свои записи при scope = own',
    appliesTo: 'crm_records'
  }
];

const auditLogs: AuditLog[] = [
  {
    id: 'log-1',
    event: 'user.login',
    user: 'ceo@example.com',
    payload: { ip: '10.0.0.4', user_agent: 'Chrome' },
    created_at: '2024-08-01T09:15:00Z'
  },
  {
    id: 'log-2',
    event: 'settings.updated',
    user: 'ceo@example.com',
    entity: 'core.settings',
    payload: { key: 'developer_mode', value: true },
    created_at: '2024-08-02T07:30:00Z'
  },
  {
    id: 'log-3',
    event: 'user.invited',
    user: 'manager@example.com',
    entity: 'users',
    payload: { email: 'new.user@example.com', department: 'Sales' },
    created_at: '2024-08-02T10:00:00Z'
  }
];

const permissionsCatalog = [
  'settings.view',
  'system.manage',
  'users.manage',
  'roles.manage',
  'languages.manage',
  'audit.view'
];

function hasPermission(permission: string, granted: string[]): boolean {
  if (granted.length === 0) {
    return true;
  }
  return granted.includes(permission);
}

export default function Settings() {
  const auth = useContext(AuthContext);

  if (!auth) {
    throw new Error('AuthContext not available');
  }

  const permissions = auth.user?.permissions ?? [];
  const permittedNav = navItems.filter((item) => hasPermission(item.permission, permissions));
  const [active, setActive] = useState<string>(permittedNav[0]?.key ?? 'system');

  useEffect(() => {
    const allowedKeys = permittedNav.map((item) => item.key);
    if (!allowedKeys.includes(active) && allowedKeys.length > 0) {
      setActive(allowedKeys[0]);
    }
  }, [active, permittedNav]);

  if (!hasPermission('settings.view', permissions)) {
    return (
      <div className="page">
        <div className="card">
          <h2 className="card__title">Недостаточно прав</h2>
          <p className="muted">Нужен permission settings.view, чтобы открыть Core Settings.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page settings-page">
      <div className="page__header">
        <div>
          <p className="muted">Core</p>
          <h1 className="page__title">Settings</h1>
        </div>
        <span className="badge">Admin</span>
      </div>

      <div className="settings-layout">
        <nav className="settings-nav">
          {navItems.map((item) => {
            const disabled = !hasPermission(item.permission, permissions);
            if (!permittedNav.find((entry) => entry.key === item.key) && disabled) {
              return null;
            }
            return (
              <button
                key={item.key}
                className={`settings-nav__item ${active === item.key ? 'is-active' : ''}`}
                type="button"
                onClick={() => setActive(item.key)}
                disabled={disabled}
              >
                <span>{item.label}</span>
                <span className="muted">{item.permission}</span>
              </button>
            );
          })}
        </nav>

        <div className="settings-content">
          {active === 'system' && <SystemSection />}
          {active === 'users' && <UsersSection />}
          {active === 'roles' && <RolesSection />}
          {active === 'languages' && <LanguagesSection />}
          {active === 'audit' && <AuditSection />}
        </div>
      </div>
    </div>
  );
}

function SystemSection() {
  const [generalState, setGeneralState] = useState({
    systemName: 'Core platform',
    defaultLanguage: languages.find((lang) => lang.isDefault)?.code || 'en',
    timezone: 'UTC',
    developerMode: true
  });
  const [securityState, setSecurityState] = useState({
    enableLocalPasswords: true,
    enableSSO: false,
    jwtTtl: 60,
    allowMultipleSessions: false
  });
  const [message, setMessage] = useState<string | null>(null);

  const handleGeneralSubmit = (event: FormEvent) => {
    event.preventDefault();
    setMessage('System general saved (POST /api/core/v1/settings/system)');
  };

  const handleSecuritySubmit = (event: FormEvent) => {
    event.preventDefault();
    setMessage('Security saved (POST /api/core/v1/settings/security)');
  };

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">System</p>
            <h2 className="card__title">General</h2>
          </div>
          <div className="pill">GET /api/core/v1/settings/system</div>
        </div>
        <form className="form two-column" onSubmit={handleGeneralSubmit}>
          <label className="form__label" htmlFor="systemName">
            System name
          </label>
          <input
            id="systemName"
            className="input"
            value={generalState.systemName}
            onChange={(e) => setGeneralState({ ...generalState, systemName: e.target.value })}
          />

          <label className="form__label" htmlFor="defaultLanguage">
            Default language
          </label>
          <select
            id="defaultLanguage"
            className="input"
            value={generalState.defaultLanguage}
            onChange={(e) => setGeneralState({ ...generalState, defaultLanguage: e.target.value })}
          >
            {languages
              .filter((lang) => lang.enabled)
              .map((lang) => (
                <option key={lang.code} value={lang.code}>
                  {lang.name}
                </option>
              ))}
          </select>

          <label className="form__label" htmlFor="timezone">
            Timezone
          </label>
          <input
            id="timezone"
            className="input"
            value={generalState.timezone}
            onChange={(e) => setGeneralState({ ...generalState, timezone: e.target.value })}
            placeholder="UTC"
          />

          <label className="form__label" htmlFor="developerMode">
            Developer mode
          </label>
          <label className="toggle">
            <input
              id="developerMode"
              type="checkbox"
              checked={generalState.developerMode}
              onChange={(e) => setGeneralState({ ...generalState, developerMode: e.target.checked })}
            />
            <span>
              {generalState.developerMode
                ? 'Логируются payload и SQL (без паролей)'
                : 'Только error / warning'}
            </span>
          </label>

          <div className="form__actions">
            <button className="button button-primary" type="submit">
              Save general
            </button>
          </div>
        </form>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">System</p>
            <h2 className="card__title">Security</h2>
          </div>
          <div className="pill">GET /api/core/v1/settings/security</div>
        </div>
        <form className="form two-column" onSubmit={handleSecuritySubmit}>
          <label className="form__label" htmlFor="localPasswords">
            Enable local passwords
          </label>
          <input
            id="localPasswords"
            type="checkbox"
            checked={securityState.enableLocalPasswords}
            onChange={(e) =>
              setSecurityState({ ...securityState, enableLocalPasswords: e.target.checked })
            }
          />

          <label className="form__label" htmlFor="enableSSO">
            Enable SSO
          </label>
          <input
            id="enableSSO"
            type="checkbox"
            checked={securityState.enableSSO}
            onChange={(e) => setSecurityState({ ...securityState, enableSSO: e.target.checked })}
          />

          <label className="form__label" htmlFor="jwtTtl">
            JWT TTL (minutes)
          </label>
          <input
            id="jwtTtl"
            className="input"
            type="number"
            min="5"
            value={securityState.jwtTtl}
            onChange={(e) => setSecurityState({ ...securityState, jwtTtl: Number(e.target.value) })}
          />

          <label className="form__label" htmlFor="multipleSessions">
            Allow multiple sessions
          </label>
          <input
            id="multipleSessions"
            type="checkbox"
            checked={securityState.allowMultipleSessions}
            onChange={(e) =>
              setSecurityState({ ...securityState, allowMultipleSessions: e.target.checked })
            }
          />

          <div className="form__actions">
            <button className="button button-primary" type="submit">
              Save security
            </button>
          </div>
        </form>
      </div>

      {message && <div className="alert">{message}</div>}
    </div>
  );
}

function UsersSection() {
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Users</p>
            <h2 className="card__title">Users</h2>
          </div>
          <div className="pill">GET /api/core/v1/users</div>
        </div>
        <div className="actions-row">
          <button className="button button-primary" type="button">
            Создать пользователя
          </button>
          <button className="button button-secondary" type="button">
            Деактивировать
          </button>
          <button className="button button-secondary" type="button">
            Сменить язык
          </button>
          <button className="button button-secondary" type="button">
            Сбросить пароль
          </button>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>Email</th>
                <th>Имя</th>
                <th>Фамилия</th>
                <th>Компания</th>
                <th>Статус</th>
                <th>Язык</th>
                <th>Роли</th>
                <th>Группы</th>
                <th>Департамент</th>
              </tr>
            </thead>
            <tbody>
              {users.map((user) => (
                <tr key={user.email}>
                  <td>{user.email}</td>
                  <td>{user.firstName}</td>
                  <td>{user.lastName}</td>
                  <td>{user.company}</td>
                  <td>
                    <span className={`status status-${user.status}`}>
                      {user.status === 'active' ? 'active' : 'inactive'}
                    </span>
                  </td>
                  <td>{user.language}</td>
                  <td>
                    <div className="tags">
                      {user.roles.map((role) => (
                        <span key={role} className="tag">
                          {role}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td>
                    <div className="tags">
                      {user.groups.map((group) => (
                        <span key={group} className="tag">
                          {group}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td>{user.department}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Users</p>
            <h2 className="card__title">Departments</h2>
          </div>
          <div className="pill">GET /api/core/v1/departments</div>
        </div>
        <div className="tree">
          <div className="tree__node">
            <div>
              <strong>CEO Office</strong>
              <p className="muted">Руководитель: Elena Morozova</p>
            </div>
            <div className="tags">
              <span className="tag">ceo@example.com</span>
            </div>
          </div>
          <div className="tree__children">
            <div className="tree__node">
              <div>
                <strong>Sales</strong>
                <p className="muted">Руководитель: Ivan Petrov</p>
              </div>
              <div className="tags">
                <span className="tag">manager@example.com</span>
                <span className="tag">sales-1@example.com</span>
              </div>
            </div>
            <div className="tree__node">
              <div>
                <strong>Operations</strong>
                <p className="muted">Руководитель: N/A</p>
              </div>
              <div className="tags">
                <span className="tag">ops@example.com</span>
              </div>
            </div>
          </div>
        </div>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            Добавить департамент
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Users</p>
            <h2 className="card__title">Groups</h2>
          </div>
          <div className="pill">GET /api/core/v1/groups</div>
        </div>
        <div className="tags">
          <span className="tag">executive</span>
          <span className="tag">sales</span>
          <span className="tag">partners</span>
          <span className="tag">support</span>
        </div>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            Добавить группу
          </button>
        </div>
      </div>
    </div>
  );
}

function RolesSection() {
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Roles & Access</p>
            <h2 className="card__title">Roles</h2>
          </div>
          <div className="pill">GET /api/core/v1/roles</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Scope</th>
                <th>Permissions</th>
              </tr>
            </thead>
            <tbody>
              {roles.map((role) => (
                <tr key={role.code}>
                  <td>{role.code}</td>
                  <td>{role.name}</td>
                  <td>
                    <span className="pill pill-muted">{role.scope}</span>
                  </td>
                  <td>
                    <div className="tags">
                      {role.permissions.map((perm) => (
                        <span key={perm} className="tag">
                          {perm}
                        </span>
                      ))}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            Добавить роль
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Roles & Access</p>
            <h2 className="card__title">Permissions</h2>
          </div>
          <div className="pill">System only</div>
        </div>
        <p className="muted">Системные permissions не редактируются, только назначаются.</p>
        <div className="tags">
          {permissionsCatalog.map((perm) => (
            <span key={perm} className="tag">
              {perm}
            </span>
          ))}
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Roles & Access</p>
            <h2 className="card__title">Access Policies (ABAC)</h2>
          </div>
          <div className="pill">GET /api/core/v1/access/policies</div>
        </div>
        <ul className="list">
          {policies.map((policy) => (
            <li key={policy.id} className="list__item">
              <p className="list__title">{policy.description}</p>
              <p className="muted">Применяется к: {policy.appliesTo}</p>
            </li>
          ))}
        </ul>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            Создать policy
          </button>
        </div>
      </div>
    </div>
  );
}

function LanguagesSection() {
  const enabledCount = languages.filter((lang) => lang.enabled).length;

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Languages</p>
            <h2 className="card__title">Languages</h2>
          </div>
          <div className="pill">GET /api/core/v1/languages</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Status</th>
                <th>Default</th>
              </tr>
            </thead>
            <tbody>
              {languages.map((lang) => (
                <tr key={lang.code}>
                  <td>{lang.code}</td>
                  <td>{lang.name}</td>
                  <td>
                    <span className={`status status-${lang.enabled ? 'active' : 'inactive'}`}>
                      {lang.enabled ? 'enabled' : 'disabled'}
                    </span>
                  </td>
                  <td>{lang.isDefault ? 'Yes' : '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="card__footer">
          <p className="muted">Включено языков: {enabledCount}</p>
          <button className="button button-secondary" type="button">
            Добавить язык
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Languages</p>
            <h2 className="card__title">Translations</h2>
          </div>
          <div className="pill">Read-only showcase</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>Key</th>
                <th>Value</th>
                <th>Language</th>
                <th>Aliases</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>settings.title</td>
                <td>Settings</td>
                <td>en</td>
                <td>—</td>
              </tr>
              <tr>
                <td>settings.title</td>
                <td>Настройки</td>
                <td>ru</td>
                <td>settings.header</td>
              </tr>
              <tr>
                <td>audit.empty</td>
                <td>No audit records</td>
                <td>en</td>
                <td>—</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function AuditSection() {
  const [filters, setFilters] = useState({
    from: '',
    to: '',
    event: '',
    q: '',
    limit: 10,
    page: 1
  });
  const [selectedLog, setSelectedLog] = useState<AuditLog | null>(auditLogs[0]);

  const filteredLogs = useMemo(() => {
    return auditLogs.filter((log) => {
      const createdAt = new Date(log.created_at);
      const fromOk = !filters.from || createdAt >= new Date(filters.from);
      const toOk = !filters.to || createdAt <= new Date(filters.to);
      const eventOk = !filters.event || log.event === filters.event;
      const q = filters.q.toLowerCase();
      const payloadPreview = JSON.stringify(log.payload).toLowerCase();
      const searchOk = !q || payloadPreview.includes(q);
      return fromOk && toOk && eventOk && searchOk;
    });
  }, [filters]);

  const pageStart = (filters.page - 1) * filters.limit;
  const paginated = filteredLogs.slice(pageStart, pageStart + filters.limit);
  const totalPages = Math.max(1, Math.ceil(filteredLogs.length / filters.limit));

  useEffect(() => {
    setFilters((prev) => ({ ...prev, page: 1 }));
  }, [filters.from, filters.to, filters.event, filters.q, filters.limit]);

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">Audit</p>
            <h2 className="card__title">Audit Logs</h2>
          </div>
          <div className="pill">GET /api/core/v1/audit</div>
        </div>

        <div className="filters">
          <label>
            From
            <input
              type="date"
              className="input"
              value={filters.from}
              onChange={(e) => setFilters({ ...filters, from: e.target.value })}
            />
          </label>
          <label>
            To
            <input
              type="date"
              className="input"
              value={filters.to}
              onChange={(e) => setFilters({ ...filters, to: e.target.value })}
            />
          </label>
          <label>
            Event
            <select
              className="input"
              value={filters.event}
              onChange={(e) => setFilters({ ...filters, event: e.target.value })}
            >
              <option value="">Any</option>
              {Array.from(new Set(auditLogs.map((log) => log.event))).map((event) => (
                <option key={event} value={event}>
                  {event}
                </option>
              ))}
            </select>
          </label>
          <label>
            Search payload
            <input
              type="search"
              className="input"
              placeholder="ILIKE payload"
              value={filters.q}
              onChange={(e) => setFilters({ ...filters, q: e.target.value })}
            />
          </label>
          <label>
            Limit
            <input
              type="number"
              min="1"
              className="input"
              value={filters.limit}
              onChange={(e) => setFilters({ ...filters, limit: Number(e.target.value) })}
            />
          </label>
        </div>

        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>Date / Time</th>
                <th>Event</th>
                <th>User</th>
                <th>Entity</th>
                <th>Payload</th>
              </tr>
            </thead>
            <tbody>
              {paginated.map((log) => (
                <tr key={log.id} className={selectedLog?.id === log.id ? 'is-selected' : ''}>
                  <td>{new Date(log.created_at).toLocaleString()}</td>
                  <td>{log.event}</td>
                  <td>{log.user || '—'}</td>
                  <td>{log.entity || '—'}</td>
                  <td>
                    <button
                      className="button button-ghost"
                      type="button"
                      onClick={() => setSelectedLog(log)}
                    >
                      {JSON.stringify(log.payload).slice(0, 60)}...
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="pagination">
          <div>
            Страница {filters.page} из {totalPages}
          </div>
          <div className="actions-row">
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.max(1, filters.page - 1) })}
              disabled={filters.page === 1}
            >
              Назад
            </button>
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.min(totalPages, filters.page + 1) })}
              disabled={filters.page >= totalPages}
            >
              Вперед
            </button>
          </div>
        </div>
      </div>

      {selectedLog && (
        <div className="card">
          <div className="card__header">
            <div>
              <p className="muted">Payload</p>
              <h2 className="card__title">{selectedLog.event}</h2>
            </div>
            <div className="pill">read-only</div>
          </div>
          <p className="muted">Источник: audit.audit_log · id {selectedLog.id}</p>
          <pre className="code-block">{JSON.stringify(selectedLog.payload, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}
