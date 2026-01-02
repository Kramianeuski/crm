import { FormEvent, useContext, useEffect, useMemo, useState } from 'react';
import { AuthContext } from '../app/App';

type TranslationKey = keyof typeof fallbackTranslations;
type Translator = (key: TranslationKey, params?: Record<string, string | number>) => string;

type NavItem = {
  key: string;
  labelKey: TranslationKey;
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

const fallbackTranslations = {
  navSystem: 'System',
  navUsers: 'Users',
  navRoles: 'Roles & Access',
  navLanguages: 'Languages',
  navAudit: 'Audit Logs',
  insufficientTitle: 'Недостаточно прав',
  insufficientDescription: 'Нужен permission settings.view, чтобы открыть Core Settings.',
  headerCoreLabel: 'Core',
  headerSettingsTitle: 'Settings',
  headerAdmin: 'Admin',
  systemSectionLabel: 'System',
  systemGeneralTitle: 'General',
  systemGeneralApi: 'GET /api/core/v1/settings/system',
  systemNameLabel: 'System name',
  defaultLanguageLabel: 'Default language',
  timezoneLabel: 'Timezone',
  developerModeLabel: 'Developer mode',
  developerModeOn: 'Логируются payload и SQL (без паролей)',
  developerModeOff: 'Только error / warning',
  saveGeneral: 'Save general',
  generalSaved: 'System general saved (POST /api/core/v1/settings/system)',
  systemSecurityTitle: 'Security',
  systemSecurityApi: 'GET /api/core/v1/settings/security',
  enableLocalPasswords: 'Enable local passwords',
  enableSSO: 'Enable SSO',
  jwtTtl: 'JWT TTL (minutes)',
  allowMultipleSessions: 'Allow multiple sessions',
  saveSecurity: 'Save security',
  securitySaved: 'Security saved (POST /api/core/v1/settings/security)',
  usersSectionLabel: 'Users',
  usersTitle: 'Users',
  usersApi: 'GET /api/core/v1/users',
  userCreate: 'Создать пользователя',
  userDeactivate: 'Деактивировать',
  userChangeLanguage: 'Сменить язык',
  userResetPassword: 'Сбросить пароль',
  userEmail: 'Email',
  userFirstName: 'Имя',
  userLastName: 'Фамилия',
  userCompany: 'Компания',
  userStatus: 'Статус',
  userLanguage: 'Язык',
  userRoles: 'Роли',
  userGroups: 'Группы',
  userDepartment: 'Департамент',
  statusActive: 'active',
  statusInactive: 'inactive',
  departmentsTitle: 'Departments',
  departmentsApi: 'GET /api/core/v1/departments',
  departmentHead: 'Руководитель',
  departmentNotAssigned: 'N/A',
  addDepartment: 'Добавить департамент',
  groupsTitle: 'Groups',
  groupsApi: 'GET /api/core/v1/groups',
  addGroup: 'Добавить группу',
  rolesSectionLabel: 'Roles & Access',
  rolesTitle: 'Roles',
  rolesApi: 'GET /api/core/v1/roles',
  roleCode: 'Code',
  roleName: 'Name',
  roleScope: 'Scope',
  rolePermissions: 'Permissions',
  addRole: 'Добавить роль',
  permissionsTitle: 'Permissions',
  permissionsPill: 'System only',
  permissionsDescription: 'Системные permissions не редактируются, только назначаются.',
  accessPoliciesTitle: 'Access Policies (ABAC)',
  accessPoliciesApi: 'GET /api/core/v1/access/policies',
  accessAppliesTo: 'Применяется к',
  createPolicy: 'Создать policy',
  languagesSectionLabel: 'Languages',
  languagesTitle: 'Languages',
  languagesApi: 'GET /api/core/v1/languages',
  languageCode: 'Code',
  languageName: 'Name',
  languageStatus: 'Status',
  languageDefault: 'Default',
  languageEnabled: 'enabled',
  languageDisabled: 'disabled',
  languageDefaultYes: 'Yes',
  languageDefaultNo: '—',
  emptyValue: '—',
  languagesEnabledCount: 'Включено языков: {count}',
  addLanguage: 'Добавить язык',
  translationsTitle: 'Translations',
  translationsPill: 'Read-only showcase',
  translationKey: 'Key',
  translationValue: 'Value',
  translationLanguage: 'Language',
  translationAliases: 'Aliases',
  auditSectionLabel: 'Audit',
  auditTitle: 'Audit Logs',
  auditApi: 'GET /api/core/v1/audit',
  filterFrom: 'From',
  filterTo: 'To',
  filterEvent: 'Event',
  filterAny: 'Any',
  filterSearchPayload: 'Search payload',
  filterPayloadPlaceholder: 'ILIKE payload',
  filterLimit: 'Limit',
  auditDateTime: 'Date / Time',
  auditEvent: 'Event',
  auditUser: 'User',
  auditEntity: 'Entity',
  auditPayload: 'Payload',
  paginationLabel: 'Страница {page} из {total}',
  paginationPrev: 'Назад',
  paginationNext: 'Вперед',
  payloadLabel: 'Payload',
  payloadPill: 'read-only',
  payloadSource: 'Источник: audit.audit_log · id {id}'
};

const localeTranslations: Record<string, Partial<typeof fallbackTranslations>> = {
  ru: {
    navSystem: 'Система',
    navUsers: 'Пользователи',
    navRoles: 'Роли и доступ',
    navLanguages: 'Языки',
    navAudit: 'Аудит',
    headerSettingsTitle: 'Настройки',
    headerAdmin: 'Админ',
    systemSectionLabel: 'Система',
    systemGeneralTitle: 'Общие',
    systemSecurityTitle: 'Безопасность',
    saveGeneral: 'Сохранить общие настройки',
    saveSecurity: 'Сохранить безопасность',
    usersSectionLabel: 'Пользователи',
    usersTitle: 'Пользователи',
    userCreate: 'Создать пользователя',
    userDeactivate: 'Деактивировать',
    userChangeLanguage: 'Сменить язык',
    userResetPassword: 'Сбросить пароль',
    departmentsTitle: 'Департаменты',
    groupsTitle: 'Группы',
    addGroup: 'Добавить группу',
    addDepartment: 'Добавить департамент',
    rolesSectionLabel: 'Роли и доступ',
    rolesTitle: 'Роли',
    addRole: 'Добавить роль',
    permissionsPill: 'Только системно',
    accessPoliciesTitle: 'Политики доступа (ABAC)',
    createPolicy: 'Создать политику',
    languagesSectionLabel: 'Языки',
    languagesTitle: 'Языки',
    translationsTitle: 'Переводы',
    translationsPill: 'Только чтение',
    auditSectionLabel: 'Аудит',
    auditTitle: 'Журнал аудита',
    filterAny: 'Любое',
    filterSearchPayload: 'Поиск по payload',
    filterPayloadPlaceholder: 'ILIKE payload',
    paginationPrev: 'Назад',
    paginationNext: 'Вперед',
    payloadPill: 'только чтение',
    payloadSource: 'Источник: audit.audit_log · id {id}'
  },
  pl: {
    navSystem: 'System',
    navUsers: 'Użytkownicy',
    navRoles: 'Role i dostęp',
    navLanguages: 'Języki',
    navAudit: 'Rejestr audytu'
  },
  lt: {
    navSystem: 'Sistema',
    navUsers: 'Vartotojai',
    navRoles: 'Rolės ir prieiga',
    navLanguages: 'Kalbos',
    navAudit: 'Audito žurnalas'
  }
};

function useTranslation(language?: string): Translator {
  return (key, params = {}) => {
    const locale = (language && localeTranslations[language]) || {};
    const template = locale[key] ?? fallbackTranslations[key];
    return Object.keys(params).reduce(
      (acc, token) => acc.replace(new RegExp(`{${token}}`, 'g'), String(params[token])),
      template
    );
  };
}

const navItems: NavItem[] = [
  { key: 'system', labelKey: 'navSystem', permission: 'system.manage' },
  { key: 'users', labelKey: 'navUsers', permission: 'users.manage' },
  { key: 'roles', labelKey: 'navRoles', permission: 'roles.manage' },
  { key: 'languages', labelKey: 'navLanguages', permission: 'languages.manage' },
  { key: 'audit', labelKey: 'navAudit', permission: 'audit.view' }
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
  const currentLanguage = auth.user?.lang || languages.find((lang) => lang.isDefault)?.code || 'en';
  const t = useTranslation(currentLanguage);
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
          <h2 className="card__title">{t('insufficientTitle')}</h2>
          <p className="muted">{t('insufficientDescription')}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page settings-page">
      <div className="page__header">
        <div>
          <p className="muted">{t('headerCoreLabel')}</p>
          <h1 className="page__title">{t('headerSettingsTitle')}</h1>
        </div>
        <span className="badge">{t('headerAdmin')}</span>
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
                <span>{t(item.labelKey)}</span>
                <span className="muted">{item.permission}</span>
              </button>
            );
          })}
        </nav>

        <div className="settings-content">
          {active === 'system' && <SystemSection t={t} userLanguage={currentLanguage} />}
          {active === 'users' && <UsersSection t={t} />}
          {active === 'roles' && <RolesSection t={t} />}
          {active === 'languages' && <LanguagesSection t={t} />}
          {active === 'audit' && <AuditSection t={t} />}
        </div>
      </div>
    </div>
  );
}

function SystemSection({ t, userLanguage }: { t: Translator; userLanguage: string }) {
  const [generalState, setGeneralState] = useState({
    systemName: 'Core platform',
    defaultLanguage:
      userLanguage || languages.find((lang) => lang.isDefault)?.code || 'en',
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
    setMessage(t('generalSaved'));
  };

  const handleSecuritySubmit = (event: FormEvent) => {
    event.preventDefault();
    setMessage(t('securitySaved'));
  };

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('systemSectionLabel')}</p>
            <h2 className="card__title">{t('systemGeneralTitle')}</h2>
          </div>
          <div className="pill">{t('systemGeneralApi')}</div>
        </div>
        <form className="form two-column" onSubmit={handleGeneralSubmit}>
          <label className="form__label" htmlFor="systemName">
            {t('systemNameLabel')}
          </label>
          <input
            id="systemName"
            className="input"
            value={generalState.systemName}
            onChange={(e) => setGeneralState({ ...generalState, systemName: e.target.value })}
          />

          <label className="form__label" htmlFor="defaultLanguage">
            {t('defaultLanguageLabel')}
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
            {t('timezoneLabel')}
          </label>
          <input
            id="timezone"
            className="input"
            value={generalState.timezone}
            onChange={(e) => setGeneralState({ ...generalState, timezone: e.target.value })}
            placeholder="UTC"
          />

          <label className="form__label" htmlFor="developerMode">
            {t('developerModeLabel')}
          </label>
          <label className="toggle">
            <input
              id="developerMode"
              type="checkbox"
              checked={generalState.developerMode}
              onChange={(e) => setGeneralState({ ...generalState, developerMode: e.target.checked })}
            />
            <span>
              {generalState.developerMode ? t('developerModeOn') : t('developerModeOff')}
            </span>
          </label>

          <div className="form__actions">
            <button className="button button-primary" type="submit">
              {t('saveGeneral')}
            </button>
          </div>
        </form>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('systemSectionLabel')}</p>
            <h2 className="card__title">{t('systemSecurityTitle')}</h2>
          </div>
          <div className="pill">{t('systemSecurityApi')}</div>
        </div>
        <form className="form two-column" onSubmit={handleSecuritySubmit}>
          <label className="form__label" htmlFor="localPasswords">
            {t('enableLocalPasswords')}
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
            {t('enableSSO')}
          </label>
          <input
            id="enableSSO"
            type="checkbox"
            checked={securityState.enableSSO}
            onChange={(e) => setSecurityState({ ...securityState, enableSSO: e.target.checked })}
          />

          <label className="form__label" htmlFor="jwtTtl">
            {t('jwtTtl')}
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
            {t('allowMultipleSessions')}
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
              {t('saveSecurity')}
            </button>
          </div>
        </form>
      </div>

      {message && <div className="alert">{message}</div>}
    </div>
  );
}

function UsersSection({ t }: { t: Translator }) {
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('usersSectionLabel')}</p>
            <h2 className="card__title">{t('usersTitle')}</h2>
          </div>
          <div className="pill">{t('usersApi')}</div>
        </div>
        <div className="actions-row">
          <button className="button button-primary" type="button">
            {t('userCreate')}
          </button>
          <button className="button button-secondary" type="button">
            {t('userDeactivate')}
          </button>
          <button className="button button-secondary" type="button">
            {t('userChangeLanguage')}
          </button>
          <button className="button button-secondary" type="button">
            {t('userResetPassword')}
          </button>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('userEmail')}</th>
                <th>{t('userFirstName')}</th>
                <th>{t('userLastName')}</th>
                <th>{t('userCompany')}</th>
                <th>{t('userStatus')}</th>
                <th>{t('userLanguage')}</th>
                <th>{t('userRoles')}</th>
                <th>{t('userGroups')}</th>
                <th>{t('userDepartment')}</th>
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
                      {user.status === 'active' ? t('statusActive') : t('statusInactive')}
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
            <p className="muted">{t('usersSectionLabel')}</p>
            <h2 className="card__title">{t('departmentsTitle')}</h2>
            </div>
          <div className="pill">{t('departmentsApi')}</div>
          </div>
          <div className="tree">
            <div className="tree__node">
              <div>
                <strong>CEO Office</strong>
              <p className="muted">{t('departmentHead')}: Elena Morozova</p>
              </div>
              <div className="tags">
                <span className="tag">ceo@example.com</span>
              </div>
            </div>
            <div className="tree__children">
              <div className="tree__node">
                <div>
                  <strong>Sales</strong>
                <p className="muted">{t('departmentHead')}: Ivan Petrov</p>
                </div>
                <div className="tags">
                  <span className="tag">manager@example.com</span>
                  <span className="tag">sales-1@example.com</span>
                </div>
              </div>
              <div className="tree__node">
                <div>
                  <strong>Operations</strong>
                <p className="muted">{t('departmentHead')}: {t('departmentNotAssigned')}</p>
                </div>
                <div className="tags">
                  <span className="tag">ops@example.com</span>
                </div>
              </div>
          </div>
        </div>
          <div className="card__footer">
            <button className="button button-secondary" type="button">
            {t('addDepartment')}
            </button>
          </div>
        </div>

        <div className="card">
          <div className="card__header">
            <div>
            <p className="muted">{t('usersSectionLabel')}</p>
            <h2 className="card__title">{t('groupsTitle')}</h2>
            </div>
          <div className="pill">{t('groupsApi')}</div>
          </div>
          <div className="tags">
            <span className="tag">executive</span>
            <span className="tag">sales</span>
            <span className="tag">partners</span>
            <span className="tag">support</span>
          </div>
          <div className="card__footer">
            <button className="button button-secondary" type="button">
            {t('addGroup')}
            </button>
          </div>
        </div>
      </div>
    );
}

function RolesSection({ t }: { t: Translator }) {
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('rolesSectionLabel')}</p>
            <h2 className="card__title">{t('rolesTitle')}</h2>
          </div>
          <div className="pill">{t('rolesApi')}</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('roleCode')}</th>
                <th>{t('roleName')}</th>
                <th>{t('roleScope')}</th>
                <th>{t('rolePermissions')}</th>
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
            {t('addRole')}
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('rolesSectionLabel')}</p>
            <h2 className="card__title">{t('permissionsTitle')}</h2>
          </div>
          <div className="pill">{t('permissionsPill')}</div>
        </div>
        <p className="muted">{t('permissionsDescription')}</p>
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
            <p className="muted">{t('rolesSectionLabel')}</p>
            <h2 className="card__title">{t('accessPoliciesTitle')}</h2>
          </div>
          <div className="pill">{t('accessPoliciesApi')}</div>
        </div>
        <ul className="list">
          {policies.map((policy) => (
            <li key={policy.id} className="list__item">
              <p className="list__title">{policy.description}</p>
              <p className="muted">{t('accessAppliesTo')}: {policy.appliesTo}</p>
            </li>
          ))}
        </ul>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            {t('createPolicy')}
          </button>
        </div>
      </div>
    </div>
  );
}

function LanguagesSection({ t }: { t: Translator }) {
  const enabledCount = languages.filter((lang) => lang.enabled).length;

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('languagesSectionLabel')}</p>
            <h2 className="card__title">{t('languagesTitle')}</h2>
          </div>
          <div className="pill">{t('languagesApi')}</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('languageCode')}</th>
                <th>{t('languageName')}</th>
                <th>{t('languageStatus')}</th>
                <th>{t('languageDefault')}</th>
              </tr>
            </thead>
            <tbody>
              {languages.map((lang) => (
                <tr key={lang.code}>
                  <td>{lang.code}</td>
                  <td>{lang.name}</td>
                  <td>
                    <span className={`status status-${lang.enabled ? 'active' : 'inactive'}`}>
                      {lang.enabled ? t('languageEnabled') : t('languageDisabled')}
                    </span>
                  </td>
                  <td>{lang.isDefault ? t('languageDefaultYes') : t('languageDefaultNo')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="card__footer">
          <p className="muted">{t('languagesEnabledCount', { count: enabledCount })}</p>
          <button className="button button-secondary" type="button">
            {t('addLanguage')}
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('languagesSectionLabel')}</p>
            <h2 className="card__title">{t('translationsTitle')}</h2>
          </div>
          <div className="pill">{t('translationsPill')}</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('translationKey')}</th>
                <th>{t('translationValue')}</th>
                <th>{t('translationLanguage')}</th>
                <th>{t('translationAliases')}</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>settings.title</td>
                <td>Settings</td>
                <td>en</td>
                <td>{t('emptyValue')}</td>
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
                <td>{t('emptyValue')}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function AuditSection({ t }: { t: Translator }) {
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
            <p className="muted">{t('auditSectionLabel')}</p>
            <h2 className="card__title">{t('auditTitle')}</h2>
          </div>
          <div className="pill">{t('auditApi')}</div>
        </div>

        <div className="filters">
          <label>
            {t('filterFrom')}
            <input
              type="date"
              className="input"
              value={filters.from}
              onChange={(e) => setFilters({ ...filters, from: e.target.value })}
            />
          </label>
          <label>
            {t('filterTo')}
            <input
              type="date"
              className="input"
              value={filters.to}
              onChange={(e) => setFilters({ ...filters, to: e.target.value })}
            />
          </label>
          <label>
            {t('filterEvent')}
            <select
              className="input"
              value={filters.event}
              onChange={(e) => setFilters({ ...filters, event: e.target.value })}
            >
              <option value="">{t('filterAny')}</option>
              {Array.from(new Set(auditLogs.map((log) => log.event))).map((event) => (
                <option key={event} value={event}>
                  {event}
                </option>
              ))}
            </select>
          </label>
          <label>
            {t('filterSearchPayload')}
            <input
              type="search"
              className="input"
              placeholder={t('filterPayloadPlaceholder')}
              value={filters.q}
              onChange={(e) => setFilters({ ...filters, q: e.target.value })}
            />
          </label>
          <label>
            {t('filterLimit')}
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
                <th>{t('auditDateTime')}</th>
                <th>{t('auditEvent')}</th>
                <th>{t('auditUser')}</th>
                <th>{t('auditEntity')}</th>
                <th>{t('auditPayload')}</th>
              </tr>
            </thead>
            <tbody>
              {paginated.map((log) => (
                <tr key={log.id} className={selectedLog?.id === log.id ? 'is-selected' : ''}>
                  <td>{new Date(log.created_at).toLocaleString()}</td>
                  <td>{log.event}</td>
                  <td>{log.user || t('emptyValue')}</td>
                  <td>{log.entity || t('emptyValue')}</td>
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
            {t('paginationLabel', { page: filters.page, total: totalPages })}
          </div>
          <div className="actions-row">
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.max(1, filters.page - 1) })}
              disabled={filters.page === 1}
            >
              {t('paginationPrev')}
            </button>
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.min(totalPages, filters.page + 1) })}
              disabled={filters.page >= totalPages}
            >
              {t('paginationNext')}
            </button>
          </div>
        </div>
      </div>

      {selectedLog && (
        <div className="card">
          <div className="card__header">
            <div>
              <p className="muted">{t('payloadLabel')}</p>
              <h2 className="card__title">{selectedLog.event}</h2>
            </div>
            <div className="pill">{t('payloadPill')}</div>
          </div>
          <p className="muted">{t('payloadSource', { id: selectedLog.id })}</p>
          <pre className="code-block">{JSON.stringify(selectedLog.payload, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}
