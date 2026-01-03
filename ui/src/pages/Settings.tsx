import { FormEvent, useContext, useEffect, useMemo, useState } from 'react';
import { AuthContext } from '../app/App';
import { Language, createLanguage, updateLanguage } from '../app/api';
import { useI18n } from '../app/i18n';

type NavItem = {
  key: string;
  labelKey: string;
  permission: string;
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
  nameKey: string;
  scope: 'none' | 'own' | 'department' | 'all';
  permissions: string[];
};

type AccessPolicy = {
  id: string;
  descriptionKey: string;
  appliesToKey: string;
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
  { key: 'system', labelKey: 'settings_nav_system', permission: 'system.manage' },
  { key: 'users', labelKey: 'settings_nav_users', permission: 'users.manage' },
  { key: 'roles', labelKey: 'settings_nav_roles', permission: 'roles.manage' },
  { key: 'languages', labelKey: 'settings_nav_languages', permission: 'languages.manage' },
  { key: 'audit', labelKey: 'settings_nav_audit', permission: 'audit.view' }
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
    nameKey: 'roles_owner_name',
    scope: 'all',
    permissions: ['settings.view', 'system.manage', 'roles.manage', 'users.manage', 'languages.manage', 'audit.view']
  },
  {
    code: 'manager',
    nameKey: 'roles_manager_name',
    scope: 'department',
    permissions: ['settings.view', 'users.manage', 'audit.view']
  },
  {
    code: 'viewer',
    nameKey: 'roles_viewer_name',
    scope: 'own',
    permissions: ['settings.view', 'audit.view']
  }
];

const policies: AccessPolicy[] = [
  {
    id: 'policy-1',
    descriptionKey: 'policies_invite_only_managers',
    appliesToKey: 'settings_users_title'
  },
  {
    id: 'policy-2',
    descriptionKey: 'policies_vendor_scope',
    appliesToKey: 'settings_roles_permissions'
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
  const { t } = useI18n();

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
          <h2 className="card__title">{t('settings_access_denied_title')}</h2>
          <p className="muted">{t('settings_access_denied_body')}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page settings-page">
      <div className="page__header">
        <div>
          <p className="muted">{t('settings_scope_core')}</p>
          <h1 className="page__title">{t('settings_title')}</h1>
        </div>
        <span className="badge">{t('settings_badge_admin')}</span>
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
  const { t, languages, defaultLanguage } = useI18n();
  const [generalState, setGeneralState] = useState({
    systemName: 'Core platform',
    defaultLanguage: defaultLanguage || 'en',
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

  useEffect(() => {
    setGeneralState((prev) => ({ ...prev, defaultLanguage: defaultLanguage || prev.defaultLanguage }));
  }, [defaultLanguage]);

  const handleGeneralSubmit = (event: FormEvent) => {
    event.preventDefault();
    setMessage(t('settings_system_saved'));
  };

  const handleSecuritySubmit = (event: FormEvent) => {
    event.preventDefault();
    setMessage(t('settings_security_saved'));
  };

  return (
    <div className="stack">
      <div className="card">
          <div className="card__header">
            <div>
            <p className="muted">{t('settings_system_label')}</p>
            <h2 className="card__title">{t('settings_system_general')}</h2>
            </div>
          <div className="pill">GET /api/core/v1/settings/system</div>
        </div>
        <form className="form two-column" onSubmit={handleGeneralSubmit}>
          <label className="form__label" htmlFor="systemName">
            {t('settings_system_name')}
          </label>
          <input
            id="systemName"
            className="input"
            value={generalState.systemName}
            onChange={(e) => setGeneralState({ ...generalState, systemName: e.target.value })}
          />

          <label className="form__label" htmlFor="defaultLanguage">
            {t('settings_system_default_language')}
          </label>
          <select
            id="defaultLanguage"
            className="input"
            value={generalState.defaultLanguage}
            onChange={(e) => setGeneralState({ ...generalState, defaultLanguage: e.target.value })}
          >
            {languages
              .filter((lang) => lang.is_active)
              .map((lang) => (
                <option key={lang.code} value={lang.code}>
                  {lang.name}
                </option>
              ))}
          </select>

          <label className="form__label" htmlFor="timezone">
            {t('settings_system_timezone')}
          </label>
          <input
            id="timezone"
            className="input"
            value={generalState.timezone}
            onChange={(e) => setGeneralState({ ...generalState, timezone: e.target.value })}
            placeholder="UTC"
          />

          <label className="form__label" htmlFor="developerMode">
            {t('settings_system_developer_mode')}
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
                ? t('settings_system_developer_mode_on')
                : t('settings_system_developer_mode_off')}
            </span>
          </label>

          <div className="form__actions">
            <button className="button button-primary" type="submit">
              {t('settings_system_save_general')}
            </button>
          </div>
        </form>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_system_label')}</p>
            <h2 className="card__title">{t('settings_system_security')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/settings/security</div>
        </div>
        <form className="form two-column" onSubmit={handleSecuritySubmit}>
          <label className="form__label" htmlFor="localPasswords">
            {t('settings_security_local_passwords')}
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
            {t('settings_security_sso')}
          </label>
          <input
            id="enableSSO"
            type="checkbox"
            checked={securityState.enableSSO}
            onChange={(e) => setSecurityState({ ...securityState, enableSSO: e.target.checked })}
          />

          <label className="form__label" htmlFor="jwtTtl">
            {t('settings_security_jwt_ttl')}
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
            {t('settings_security_multiple_sessions')}
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
              {t('settings_security_save')}
            </button>
          </div>
        </form>
      </div>

      {message && <div className="alert">{message}</div>}
    </div>
  );
}

function UsersSection() {
  const { t } = useI18n();
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_users_label')}</p>
            <h2 className="card__title">{t('settings_users_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/users</div>
        </div>
        <div className="actions-row">
          <button className="button button-primary" type="button">
            {t('settings_users_create')}
          </button>
          <button className="button button-secondary" type="button">
            {t('settings_users_deactivate')}
          </button>
          <button className="button button-secondary" type="button">
            {t('settings_users_change_language')}
          </button>
          <button className="button button-secondary" type="button">
            {t('settings_users_reset_password')}
          </button>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('settings_users_email')}</th>
                <th>{t('settings_users_first_name')}</th>
                <th>{t('settings_users_last_name')}</th>
                <th>{t('settings_users_company')}</th>
                <th>{t('settings_users_status')}</th>
                <th>{t('settings_users_language')}</th>
                <th>{t('settings_users_roles')}</th>
                <th>{t('settings_users_groups')}</th>
                <th>{t('settings_users_department')}</th>
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
                      {user.status === 'active' ? t('status_active') : t('status_inactive')}
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
            <p className="muted">{t('settings_users_label')}</p>
            <h2 className="card__title">{t('settings_departments_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/departments</div>
        </div>
        <div className="tree">
          <div className="tree__node">
            <div>
              <strong>CEO Office</strong>
              <p className="muted">{t('settings_departments_lead')}: Elena Morozova</p>
            </div>
            <div className="tags">
              <span className="tag">ceo@example.com</span>
            </div>
          </div>
          <div className="tree__children">
            <div className="tree__node">
              <div>
                <strong>Sales</strong>
                <p className="muted">{t('settings_departments_lead')}: Ivan Petrov</p>
              </div>
              <div className="tags">
                <span className="tag">manager@example.com</span>
                <span className="tag">sales-1@example.com</span>
              </div>
            </div>
            <div className="tree__node">
              <div>
                <strong>Operations</strong>
                <p className="muted">{t('settings_departments_lead')}: N/A</p>
              </div>
              <div className="tags">
                <span className="tag">ops@example.com</span>
              </div>
            </div>
          </div>
        </div>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            {t('settings_departments_add')}
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_users_label')}</p>
            <h2 className="card__title">{t('settings_groups_title')}</h2>
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
            {t('settings_groups_add')}
          </button>
        </div>
      </div>
    </div>
  );
}

function RolesSection() {
  const { t } = useI18n();
  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_roles_label')}</p>
            <h2 className="card__title">{t('settings_roles_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/roles</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('settings_roles_code')}</th>
                <th>{t('settings_roles_name')}</th>
                <th>{t('settings_roles_scope')}</th>
                <th>{t('settings_roles_permissions')}</th>
              </tr>
            </thead>
            <tbody>
              {roles.map((role) => (
                <tr key={role.code}>
                  <td>{role.code}</td>
                  <td>{t(role.nameKey)}</td>
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
            {t('settings_roles_add')}
          </button>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_roles_label')}</p>
            <h2 className="card__title">{t('settings_permissions_title')}</h2>
          </div>
          <div className="pill">System only</div>
        </div>
        <p className="muted">{t('settings_permissions_hint')}</p>
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
            <p className="muted">{t('settings_roles_label')}</p>
            <h2 className="card__title">{t('settings_policies_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/access/policies</div>
        </div>
        <ul className="list">
          {policies.map((policy) => (
            <li key={policy.id} className="list__item">
              <p className="list__title">{t(policy.descriptionKey)}</p>
              <p className="muted">{t('settings_policies_apply')}: {t(policy.appliesToKey)}</p>
            </li>
          ))}
        </ul>
        <div className="card__footer">
          <button className="button button-secondary" type="button">
            {t('settings_policies_add')}
          </button>
        </div>
      </div>
    </div>
  );
}

function LanguagesSection() {
  const { t, languages, defaultLanguage, translations, registerTranslation, refresh } = useI18n();
  const enabledCount = languages.filter((lang) => lang.is_active).length;
  const [languageForm, setLanguageForm] = useState({ code: '', name: '', is_default: false });
  const [translationForm, setTranslationForm] = useState({ key: '', value: '', language: defaultLanguage || 'en' });
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    setTranslationForm((prev) => ({ ...prev, language: defaultLanguage || prev.language }));
  }, [defaultLanguage]);

  const translationRows = useMemo(
    () =>
      Object.entries(translations).flatMap(([lang, entries]) =>
        Object.entries(entries).map(([key, value]) => ({ key, value, language: lang }))
      ),
    [translations]
  );

  const handleLanguageSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setSaving(true);
    try {
      await createLanguage({
        code: languageForm.code,
        name: languageForm.name,
        is_active: true,
        is_default: languageForm.is_default
      });
      setLanguageForm({ code: '', name: '', is_default: false });
      await refresh();
    } finally {
      setSaving(false);
    }
  };

  const handleStatusToggle = async (lang: Language, active: boolean) => {
    await updateLanguage(lang.code, { is_active: active });
    await refresh();
  };

  const handleDefaultToggle = async (lang: Language) => {
    await updateLanguage(lang.code, { is_default: true, is_active: true });
    await refresh();
  };

  const handleTranslationSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setSaving(true);
    try {
      await registerTranslation(translationForm.key, { [translationForm.language]: translationForm.value });
      setTranslationForm({ key: '', value: '', language: defaultLanguage || 'en' });
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_languages_label')}</p>
            <h2 className="card__title">{t('settings_languages_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/i18n/languages</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('settings_languages_code')}</th>
                <th>{t('settings_languages_name')}</th>
                <th>{t('settings_languages_status')}</th>
                <th>{t('settings_languages_default')}</th>
              </tr>
            </thead>
            <tbody>
              {languages.map((lang) => (
                <tr key={lang.code}>
                  <td>{lang.code}</td>
                  <td>{lang.name}</td>
                  <td>
                    <label className="toggle">
                      <input
                        type="checkbox"
                        checked={lang.is_active}
                        onChange={(e) => handleStatusToggle(lang, e.target.checked)}
                      />
                      <span>{lang.is_active ? t('status_enabled') : t('status_disabled')}</span>
                    </label>
                  </td>
                  <td>
                    <label className="toggle">
                      <input
                        type="radio"
                        name="default-language"
                        checked={lang.is_default}
                        onChange={() => handleDefaultToggle(lang)}
                      />
                      <span>{lang.is_default ? t('status_yes') : t('status_no')}</span>
                    </label>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="card__footer">
          <p className="muted">{t('settings_languages_enabled_count', { count: enabledCount })}</p>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_languages_label')}</p>
            <h2 className="card__title">{t('settings_languages_form_title')}</h2>
          </div>
          <div className="pill">POST /api/core/v1/i18n/languages</div>
        </div>
        <form className="form" onSubmit={handleLanguageSubmit}>
          <label className="form__label" htmlFor="langCode">
            {t('settings_languages_form_code')}
          </label>
          <input
            id="langCode"
            className="input"
            value={languageForm.code}
            onChange={(e) => setLanguageForm({ ...languageForm, code: e.target.value })}
            required
          />

          <label className="form__label" htmlFor="langName">
            {t('settings_languages_form_name')}
          </label>
          <input
            id="langName"
            className="input"
            value={languageForm.name}
            onChange={(e) => setLanguageForm({ ...languageForm, name: e.target.value })}
            required
          />

          <label className="toggle">
            <input
              type="checkbox"
              checked={languageForm.is_default}
              onChange={(e) => setLanguageForm({ ...languageForm, is_default: e.target.checked })}
            />
            <span>{t('settings_languages_form_is_default')}</span>
          </label>

          <div className="form__actions">
            <button className="button button-primary" type="submit" disabled={saving}>
              {t('settings_languages_form_submit')}
            </button>
          </div>
        </form>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_languages_label')}</p>
            <h2 className="card__title">{t('settings_translations_title')}</h2>
          </div>
          <div className="pill">/api/core/v1/i18n/translations</div>
        </div>
        <form className="form" onSubmit={handleTranslationSubmit}>
          <label className="form__label" htmlFor="translationKey">
            {t('settings_translations_form_key')}
          </label>
          <input
            id="translationKey"
            className="input"
            value={translationForm.key}
            onChange={(e) => setTranslationForm({ ...translationForm, key: e.target.value })}
            required
          />

          <label className="form__label" htmlFor="translationLanguage">
            {t('settings_translations_form_language')}
          </label>
          <select
            id="translationLanguage"
            className="input"
            value={translationForm.language}
            onChange={(e) => setTranslationForm({ ...translationForm, language: e.target.value })}
          >
            {languages.map((lang) => (
              <option key={lang.code} value={lang.code}>
                {lang.name}
              </option>
            ))}
          </select>

          <label className="form__label" htmlFor="translationValue">
            {t('settings_translations_form_value')}
          </label>
          <input
            id="translationValue"
            className="input"
            value={translationForm.value}
            onChange={(e) => setTranslationForm({ ...translationForm, value: e.target.value })}
            required
          />

          <div className="form__actions">
            <button className="button button-primary" type="submit" disabled={saving}>
              {t('settings_translations_form_submit')}
            </button>
          </div>
        </form>

        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('settings_translations_key')}</th>
                <th>{t('settings_translations_value')}</th>
                <th>{t('settings_translations_language')}</th>
                <th>{t('settings_translations_aliases')}</th>
              </tr>
            </thead>
            <tbody>
              {translationRows.map((row) => (
                <tr key={`${row.key}-${row.language}`}>
                  <td>{row.key}</td>
                  <td>{row.value}</td>
                  <td>{row.language}</td>
                  <td>{t('status_no')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function AuditSection() {
  const { t } = useI18n();
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
            <p className="muted">{t('settings_audit_label')}</p>
            <h2 className="card__title">{t('settings_audit_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/audit</div>
        </div>

        <div className="filters">
          <label>
            {t('settings_audit_filter_from')}
            <input
              type="date"
              className="input"
              value={filters.from}
              onChange={(e) => setFilters({ ...filters, from: e.target.value })}
            />
          </label>
          <label>
            {t('settings_audit_filter_to')}
            <input
              type="date"
              className="input"
              value={filters.to}
              onChange={(e) => setFilters({ ...filters, to: e.target.value })}
            />
          </label>
          <label>
            {t('settings_audit_filter_event')}
            <select
              className="input"
              value={filters.event}
              onChange={(e) => setFilters({ ...filters, event: e.target.value })}
            >
              <option value="">{t('settings_audit_filter_any')}</option>
              {Array.from(new Set(auditLogs.map((log) => log.event))).map((event) => (
                <option key={event} value={event}>
                  {event}
                </option>
              ))}
            </select>
          </label>
          <label>
            {t('settings_audit_filter_search')}
            <input
              type="search"
              className="input"
              placeholder={t('settings_audit_filter_search')}
              value={filters.q}
              onChange={(e) => setFilters({ ...filters, q: e.target.value })}
            />
          </label>
          <label>
            {t('settings_audit_filter_limit')}
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
                <th>{t('settings_audit_table_date')}</th>
                <th>{t('settings_audit_table_event')}</th>
                <th>{t('settings_audit_table_user')}</th>
                <th>{t('settings_audit_table_entity')}</th>
                <th>{t('settings_audit_table_payload')}</th>
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
            {t('settings_audit_page', { page: filters.page, total: totalPages })}
          </div>
          <div className="actions-row">
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.max(1, filters.page - 1) })}
              disabled={filters.page === 1}
            >
              {t('common_prev')}
            </button>
            <button
              className="button button-secondary"
              type="button"
              onClick={() => setFilters({ ...filters, page: Math.min(totalPages, filters.page + 1) })}
              disabled={filters.page >= totalPages}
            >
              {t('common_next')}
            </button>
          </div>
        </div>
      </div>

      {selectedLog && (
        <div className="card">
          <div className="card__header">
            <div>
              <p className="muted">{t('settings_audit_table_payload')}</p>
              <h2 className="card__title">{selectedLog.event}</h2>
            </div>
            <div className="pill">{t('common_read_only')}</div>
          </div>
          <p className="muted">{t('settings_audit_payload_source', { id: selectedLog.id })}</p>
          <pre className="code-block">{JSON.stringify(selectedLog.payload, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}
