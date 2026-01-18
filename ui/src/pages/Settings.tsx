import { FormEvent, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { AuthContext } from '../app/App';
import {
  AuditLog,
  Department,
  Language,
  Permission,
  Role,
  UserDetail,
  UserSummary,
  createDepartment,
  createLanguage,
  fetchAuditLogs,
  fetchDepartments,
  fetchPermissions,
  fetchRoles,
  fetchSettings,
  fetchUser,
  fetchUsers,
  updateDepartment,
  updateLanguage,
  updateSettings,
  updateUser
} from '../app/api';
import { NAV_GROUPS } from '../app/navigation';
import { useI18n } from '../app/i18n';

type Toast = {
  id: string;
  message: string;
  variant: 'success' | 'error';
};

function hasPermission(permission: string, granted: string[]): boolean {
  return granted.includes(permission);
}

function ReadOnlyField({ label, value }: { label: string; value: string }) {
  return (
    <div className="read-only-field">
      <span className="form__label">{label}</span>
      <span className="read-only-field__value">{value}</span>
    </div>
  );
}

export default function Settings() {
  const auth = useContext(AuthContext);
  const { t } = useI18n();
  const location = useLocation();
  const navigate = useNavigate();

  if (!auth) {
    throw new Error('AuthContext not available');
  }

  const permissions = auth.user?.permissions ?? [];
  const navItems = useMemo(() => NAV_GROUPS.flatMap((group) => group.items), []);
  const permittedNav = navItems.filter((item) => hasPermission(item.permission, permissions));
  const [active, setActive] = useState<string>(permittedNav[0]?.key ?? 'system');
  const [toasts, setToasts] = useState<Toast[]>([]);

  const notify = useCallback((message: string, variant: Toast['variant']) => {
    const id = `${Date.now()}-${Math.random()}`;
    setToasts((prev) => [...prev, { id, message, variant }]);
    setTimeout(() => {
      setToasts((prev) => prev.filter((toast) => toast.id !== id));
    }, 4000);
  }, []);

  useEffect(() => {
    const allowedKeys = permittedNav.map((item) => item.key);
    const hashKey = location.hash.replace('#', '');
    if (hashKey && allowedKeys.includes(hashKey) && hashKey !== active) {
      setActive(hashKey);
      return;
    }
    if (!allowedKeys.includes(active) && allowedKeys.length > 0) {
      setActive(allowedKeys[0]);
    }
  }, [active, location.hash, permittedNav]);

  if (permittedNav.length === 0) {
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
          {NAV_GROUPS.map((group) => {
            const groupItems = group.items.filter((item) =>
              hasPermission(item.permission, permissions)
            );
            if (groupItems.length === 0) return null;
            return (
              <div key={group.key} className="settings-nav__group">
                <p className="settings-nav__title">{t(group.labelKey)}</p>
                {groupItems.map((item) => (
                  <button
                    key={item.key}
                    className={`settings-nav__item ${active === item.key ? 'is-active' : ''}`}
                    type="button"
                    onClick={() => {
                      setActive(item.key);
                      navigate(`/settings#${item.key}`, { replace: true });
                    }}
                  >
                    <span>{t(item.labelKey)}</span>
                    <span className="muted">{item.permission}</span>
                  </button>
                ))}
              </div>
            );
          })}
        </nav>

        <div className="settings-content">
          {active === 'system' && (
            <SystemSection permissions={permissions} onNotify={notify} />
          )}
          {active === 'users' && (
            <UsersSection permissions={permissions} onNotify={notify} />
          )}
          {active === 'departments' && (
            <DepartmentsSection permissions={permissions} onNotify={notify} />
          )}
          {active === 'roles' && <RolesSection permissions={permissions} />}
          {active === 'languages' && (
            <LanguagesSection permissions={permissions} onNotify={notify} />
          )}
          {active === 'audit' && (
            <AuditSection permissions={permissions} onNotify={notify} />
          )}
        </div>
      </div>

      {toasts.length > 0 && (
        <div className="toast-stack" role="status" aria-live="polite">
          {toasts.map((toast) => (
            <div key={toast.id} className={`toast toast-${toast.variant}`}>
              {toast.message}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function SystemSection({
  permissions,
  onNotify
}: {
  permissions: string[];
  onNotify: (message: string, variant: Toast['variant']) => void;
}) {
  const { t, languages, defaultLanguage } = useI18n();
  const canEditSystem = hasPermission('settings.system.edit', permissions);
  const canEditAccess = hasPermission('settings.users.edit', permissions);
  const [generalState, setGeneralState] = useState({
    systemName: '',
    defaultLanguage: defaultLanguage || 'en',
    timezone: 'UTC',
    developerMode: false
  });
  const [securityState, setSecurityState] = useState({
    enableLocalPasswords: true,
    enableSSO: false,
    jwtTtl: 60,
    allowMultipleSessions: false
  });

  useEffect(() => {
    setGeneralState((prev) => ({
      ...prev,
      defaultLanguage: defaultLanguage || prev.defaultLanguage
    }));
  }, [defaultLanguage]);

  useEffect(() => {
    const loadSettings = async () => {
      try {
        const data = await fetchSettings();
        setGeneralState({
          systemName: data.system.systemName,
          defaultLanguage: data.system.defaultLanguage,
          timezone: data.system.timezone,
          developerMode: data.system.developerMode
        });
        setSecurityState({
          enableLocalPasswords: data.security.enableLocalPasswords,
          enableSSO: data.security.enableSSO,
          jwtTtl: data.security.jwtTtl,
          allowMultipleSessions: data.security.allowMultipleSessions
        });
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        onNotify(message, 'error');
      }
    };

    loadSettings();
  }, [onNotify]);

  const handleGeneralSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!canEditSystem) return;
    try {
      await updateSettings({ system: generalState });
      onNotify(t('settings_system_saved'), 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  const handleSecuritySubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!canEditAccess) return;
    try {
      await updateSettings({ security: securityState });
      onNotify(t('settings_security_saved'), 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_system_label')}</p>
            <h2 className="card__title">{t('settings_system_general')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/settings</div>
        </div>
        {canEditSystem ? (
          <form className="form two-column" onSubmit={handleGeneralSubmit}>
            <label className="form__label" htmlFor="systemName">
              {t('settings_system_name')}
            </label>
            <input
              id="systemName"
              className="input"
              value={generalState.systemName}
              onChange={(e) =>
                setGeneralState({ ...generalState, systemName: e.target.value })
              }
            />

            <label className="form__label" htmlFor="defaultLanguage">
              {t('settings_system_default_language')}
            </label>
            <select
              id="defaultLanguage"
              className="input"
              value={generalState.defaultLanguage}
              onChange={(e) =>
                setGeneralState({ ...generalState, defaultLanguage: e.target.value })
              }
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
                onChange={(e) =>
                  setGeneralState({ ...generalState, developerMode: e.target.checked })
                }
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
        ) : (
          <div className="read-only-grid">
            <ReadOnlyField label={t('settings_system_name')} value={generalState.systemName} />
            <ReadOnlyField
              label={t('settings_system_default_language')}
              value={generalState.defaultLanguage}
            />
            <ReadOnlyField label={t('settings_system_timezone')} value={generalState.timezone} />
            <ReadOnlyField
              label={t('settings_system_developer_mode')}
              value={
                generalState.developerMode
                  ? t('settings_system_developer_mode_on')
                  : t('settings_system_developer_mode_off')
              }
            />
          </div>
        )}
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_system_label')}</p>
            <h2 className="card__title">{t('settings_system_security')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/settings</div>
        </div>
        {canEditAccess ? (
          <form className="form two-column" onSubmit={handleSecuritySubmit}>
            <label className="form__label" htmlFor="localPasswords">
              {t('settings_security_local_passwords')}
            </label>
            <label className="toggle">
              <input
                id="localPasswords"
                type="checkbox"
                checked={securityState.enableLocalPasswords}
                onChange={(e) =>
                  setSecurityState({
                    ...securityState,
                    enableLocalPasswords: e.target.checked
                  })
                }
              />
              <span>
                {securityState.enableLocalPasswords ? t('status_enabled') : t('status_disabled')}
              </span>
            </label>

            <label className="form__label" htmlFor="enableSSO">
              {t('settings_security_sso')}
            </label>
            <label className="toggle">
              <input
                id="enableSSO"
                type="checkbox"
                checked={securityState.enableSSO}
                onChange={(e) =>
                  setSecurityState({ ...securityState, enableSSO: e.target.checked })
                }
              />
              <span>{securityState.enableSSO ? t('status_enabled') : t('status_disabled')}</span>
            </label>

            <label className="form__label" htmlFor="jwtTtl">
              {t('settings_security_jwt_ttl')}
            </label>
            <input
              id="jwtTtl"
              className="input"
              type="number"
              min="5"
              value={securityState.jwtTtl}
              onChange={(e) =>
                setSecurityState({ ...securityState, jwtTtl: Number(e.target.value) })
              }
            />

            <label className="form__label" htmlFor="multipleSessions">
              {t('settings_security_multiple_sessions')}
            </label>
            <label className="toggle">
              <input
                id="multipleSessions"
                type="checkbox"
                checked={securityState.allowMultipleSessions}
                onChange={(e) =>
                  setSecurityState({
                    ...securityState,
                    allowMultipleSessions: e.target.checked
                  })
                }
              />
              <span>
                {securityState.allowMultipleSessions ? t('status_enabled') : t('status_disabled')}
              </span>
            </label>

            <div className="form__actions">
              <button className="button button-primary" type="submit">
                {t('settings_security_save')}
              </button>
            </div>
          </form>
        ) : (
          <div className="read-only-grid">
            <ReadOnlyField
              label={t('settings_security_local_passwords')}
              value={securityState.enableLocalPasswords ? t('status_enabled') : t('status_disabled')}
            />
            <ReadOnlyField
              label={t('settings_security_sso')}
              value={securityState.enableSSO ? t('status_enabled') : t('status_disabled')}
            />
            <ReadOnlyField
              label={t('settings_security_jwt_ttl')}
              value={`${securityState.jwtTtl}`}
            />
            <ReadOnlyField
              label={t('settings_security_multiple_sessions')}
              value={securityState.allowMultipleSessions ? t('status_enabled') : t('status_disabled')}
            />
          </div>
        )}
      </div>
    </div>
  );
}

function UsersSection({
  permissions,
  onNotify
}: {
  permissions: string[];
  onNotify: (message: string, variant: Toast['variant']) => void;
}) {
  const { t, languages } = useI18n();
  const canViewUsers = hasPermission('users.view', permissions);
  const canManageUsers = hasPermission('users.manage', permissions);
  const canAssignRoles = hasPermission('users.roles.assign', permissions);
  const [users, setUsers] = useState<UserSummary[]>([]);
  const [roles, setRoles] = useState<Role[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedUserId, setSelectedUserId] = useState<string | null>(null);
  const [selectedUser, setSelectedUser] = useState<UserDetail | null>(null);
  const [editUser, setEditUser] = useState<UserDetail | null>(null);

  const loadUsers = useCallback(async () => {
    setLoading(true);
    try {
      const data = await fetchUsers();
      setUsers(data);
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    } finally {
      setLoading(false);
    }
  }, [onNotify]);

  useEffect(() => {
    if (!canViewUsers) return;
    loadUsers();
  }, [canViewUsers, loadUsers]);

  useEffect(() => {
    if (!canAssignRoles) return;
    const loadRoles = async () => {
      try {
        const data = await fetchRoles();
        setRoles(data);
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        onNotify(message, 'error');
      }
    };
    loadRoles();
  }, [canAssignRoles, onNotify]);

  useEffect(() => {
    if (!selectedUserId) {
      setSelectedUser(null);
      setEditUser(null);
      return;
    }
    const loadUser = async () => {
      try {
        const data = await fetchUser(selectedUserId);
        setSelectedUser(data);
        setEditUser(data);
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        onNotify(message, 'error');
      }
    };
    loadUser();
  }, [selectedUserId, onNotify]);

  const handleUserSave = async () => {
    if (!editUser || !selectedUser) return;
    if (!canManageUsers && !canAssignRoles) return;

    try {
      const payload: Partial<UserDetail> = {
        first_name: editUser.first_name ?? null,
        last_name: editUser.last_name ?? null,
        company_name: editUser.company_name ?? null,
        lang: editUser.lang ?? null,
        is_active: editUser.is_active,
        roles: editUser.roles
      };
      const updated = await updateUser(String(selectedUser.id), payload);
      setSelectedUser(updated);
      setEditUser(updated);
      await loadUsers();
      onNotify('User updated.', 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  const getUserDepartments = (user: UserSummary): string => {
    if (user.departments && user.departments.length > 0) {
      return user.departments
        .map((dept) => dept.name || dept.name_key || dept.code || '—')
        .join(', ');
    }
    return '—';
  };

  if (!canViewUsers) {
    return (
      <div className="card">
        <h2 className="card__title">{t('settings_access_denied_title')}</h2>
        <p className="muted">{t('settings_access_denied_body')}</p>
      </div>
    );
  }

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
              {loading && (
                <tr>
                  <td colSpan={9} className="muted">
                    Loading...
                  </td>
                </tr>
              )}
              {!loading && users.length === 0 && (
                <tr>
                  <td colSpan={9} className="muted">
                    No users found.
                  </td>
                </tr>
              )}
              {users.map((user) => (
                <tr key={user.id}>
                  <td>
                    <button
                      className="button button-ghost"
                      type="button"
                      onClick={() => setSelectedUserId(String(user.id))}
                    >
                      {user.email}
                    </button>
                  </td>
                  <td>{user.first_name || '—'}</td>
                  <td>{user.last_name || '—'}</td>
                  <td>{user.company_name || '—'}</td>
                  <td>
                    <span className={`status status-${user.is_active ? 'active' : 'inactive'}`}>
                      {user.is_active ? t('status_active') : t('status_inactive')}
                    </span>
                  </td>
                  <td>{user.lang || '—'}</td>
                  <td>
                    <div className="tags">
                      {(user.roles || []).length === 0 && <span className="muted">—</span>}
                      {(user.roles || []).map((role) => (
                        <span key={role} className="tag">
                          {role}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td>
                    <div className="tags">
                      {(user.groups || []).length === 0 && <span className="muted">—</span>}
                      {(user.groups || []).map((group) => (
                        <span key={group} className="tag">
                          {group}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td>{getUserDepartments(user)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {selectedUserId && (
        <div className="drawer-overlay" role="dialog" aria-modal="true">
          <div className="drawer">
            <div className="drawer__header">
              <div>
                <p className="muted">{t('settings_users_label')}</p>
                <h2 className="card__title">
                  {selectedUser?.email || t('settings_users_title')}
                </h2>
              </div>
              <button
                className="button button-secondary"
                type="button"
                onClick={() => setSelectedUserId(null)}
              >
                Close
              </button>
            </div>

            {!selectedUser && <p className="muted">Loading...</p>}

            {selectedUser && editUser && (
              <div className="stack">
                <ReadOnlyField label={t('settings_users_email')} value={selectedUser.email} />
                {!canManageUsers && (
                  <>
                    <ReadOnlyField
                      label={t('settings_users_first_name')}
                      value={selectedUser.first_name || '—'}
                    />
                    <ReadOnlyField
                      label={t('settings_users_last_name')}
                      value={selectedUser.last_name || '—'}
                    />
                    <ReadOnlyField
                      label={t('settings_users_company')}
                      value={selectedUser.company_name || '—'}
                    />
                    <ReadOnlyField
                      label={t('settings_users_language')}
                      value={selectedUser.lang || '—'}
                    />
                  </>
                )}

                {canManageUsers && (
                  <form className="form">
                    <label className="form__label" htmlFor="userFirstName">
                      {t('settings_users_first_name')}
                    </label>
                    <input
                      id="userFirstName"
                      className="input"
                      value={editUser.first_name || ''}
                      onChange={(event) =>
                        setEditUser({ ...editUser, first_name: event.target.value })
                      }
                    />

                    <label className="form__label" htmlFor="userLastName">
                      {t('settings_users_last_name')}
                    </label>
                    <input
                      id="userLastName"
                      className="input"
                      value={editUser.last_name || ''}
                      onChange={(event) =>
                        setEditUser({ ...editUser, last_name: event.target.value })
                      }
                    />

                    <label className="form__label" htmlFor="userCompany">
                      {t('settings_users_company')}
                    </label>
                    <input
                      id="userCompany"
                      className="input"
                      value={editUser.company_name || ''}
                      onChange={(event) =>
                        setEditUser({ ...editUser, company_name: event.target.value })
                      }
                    />

                    <label className="form__label" htmlFor="userLang">
                      {t('settings_users_language')}
                    </label>
                    <select
                      id="userLang"
                      className="input"
                      value={editUser.lang || ''}
                      onChange={(event) => setEditUser({ ...editUser, lang: event.target.value })}
                    >
                      <option value="">—</option>
                      {languages.map((lang) => (
                        <option key={lang.code} value={lang.code}>
                          {lang.name}
                        </option>
                      ))}
                    </select>

                    <label className="form__label" htmlFor="userActive">
                      {t('settings_users_status')}
                    </label>
                    <label className="toggle">
                      <input
                        id="userActive"
                        type="checkbox"
                        checked={!!editUser.is_active}
                        onChange={(event) =>
                          setEditUser({ ...editUser, is_active: event.target.checked })
                        }
                      />
                      <span>
                        {editUser.is_active ? t('status_active') : t('status_inactive')}
                      </span>
                    </label>
                  </form>
                )}

                {canAssignRoles && (
                  <div className="card">
                    <p className="muted">{t('settings_users_roles')}</p>
                    <div className="tags">
                      {roles.map((role) => {
                        const isChecked = (editUser.roles || []).includes(role.code);
                        return (
                          <label key={role.code} className="tag tag-selectable">
                            <input
                              type="checkbox"
                              checked={isChecked}
                              onChange={(event) => {
                                const nextRoles = new Set(editUser.roles || []);
                                if (event.target.checked) {
                                  nextRoles.add(role.code);
                                } else {
                                  nextRoles.delete(role.code);
                                }
                                setEditUser({
                                  ...editUser,
                                  roles: Array.from(nextRoles)
                                });
                              }}
                            />
                            <span>{role.code}</span>
                          </label>
                        );
                      })}
                    </div>
                  </div>
                )}

                {(canManageUsers || canAssignRoles) && (
                  <div className="drawer__footer">
                    <button
                      className="button button-primary"
                      type="button"
                      onClick={handleUserSave}
                    >
                      Save
                    </button>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function DepartmentsSection({
  permissions,
  onNotify
}: {
  permissions: string[];
  onNotify: (message: string, variant: Toast['variant']) => void;
}) {
  const { t } = useI18n();
  const canViewDepartments = hasPermission('departments.view', permissions);
  const canManageDepartments = hasPermission('departments.manage', permissions);
  const canViewUsers = hasPermission('users.view', permissions);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [users, setUsers] = useState<UserSummary[]>([]);
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingDepartment, setEditingDepartment] = useState<Department | null>(null);
  const [departmentForm, setDepartmentForm] = useState({
    code: '',
    name: '',
    parent_id: '',
    manager_user_id: ''
  });

  const loadDepartments = useCallback(async () => {
    setLoading(true);
    try {
      const data = await fetchDepartments();
      setDepartments(data);
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    } finally {
      setLoading(false);
    }
  }, [onNotify]);

  useEffect(() => {
    if (!canViewDepartments) return;
    loadDepartments();
  }, [canViewDepartments, loadDepartments]);

  useEffect(() => {
    if (!canViewUsers) return;
    const loadUsers = async () => {
      try {
        const data = await fetchUsers();
        setUsers(data);
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        onNotify(message, 'error');
      }
    };
    loadUsers();
  }, [canViewUsers, onNotify]);

  const openCreateModal = () => {
    setEditingDepartment(null);
    setDepartmentForm({ code: '', name: '', parent_id: '', manager_user_id: '' });
    setModalOpen(true);
  };

  const openEditModal = (department: Department) => {
    setEditingDepartment(department);
    setDepartmentForm({
      code: department.code,
      name: department.name || department.name_key || '',
      parent_id: department.parent_id || '',
      manager_user_id: department.manager_user_id || ''
    });
    setModalOpen(true);
  };

  const handleDepartmentSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!canManageDepartments) return;
    try {
      if (editingDepartment) {
        await updateDepartment(editingDepartment.id, {
          code: departmentForm.code,
          name: departmentForm.name,
          parent_id: departmentForm.parent_id || null,
          manager_user_id: departmentForm.manager_user_id || null
        });
      } else {
        await createDepartment({
          code: departmentForm.code,
          name: departmentForm.name,
          parent_id: departmentForm.parent_id || null,
          manager_user_id: departmentForm.manager_user_id || null
        });
      }
      setModalOpen(false);
      await loadDepartments();
      onNotify('Department saved.', 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  const resolveDepartmentName = (department: Department) =>
    department.name || department.name_key || department.code;

  if (!canViewDepartments) {
    return (
      <div className="card">
        <h2 className="card__title">{t('settings_access_denied_title')}</h2>
        <p className="muted">{t('settings_access_denied_body')}</p>
      </div>
    );
  }

  return (
    <div className="stack">
      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_users_label')}</p>
            <h2 className="card__title">{t('settings_departments_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/departments</div>
        </div>
        <div className="table-wrapper">
          <table className="table">
            <thead>
              <tr>
                <th>{t('settings_departments_title')}</th>
                <th>{t('settings_departments_lead')}</th>
                <th>{t('settings_users_department')}</th>
                {canManageDepartments && <th>Actions</th>}
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={canManageDepartments ? 4 : 3} className="muted">
                    Loading...
                  </td>
                </tr>
              )}
              {!loading && departments.length === 0 && (
                <tr>
                  <td colSpan={canManageDepartments ? 4 : 3} className="muted">
                    No departments found.
                  </td>
                </tr>
              )}
              {departments.map((department) => (
                <tr key={department.id}>
                  <td>{resolveDepartmentName(department)}</td>
                  <td>{
                    department.manager?.email ||
                    department.manager?.first_name ||
                    department.manager_user_id ||
                    '—'
                  }</td>
                  <td>
                    {department.parent_id
                      ? resolveDepartmentName(
                          departments.find((item) => item.id === department.parent_id) || department
                        )
                      : '—'}
                  </td>
                  {canManageDepartments && (
                    <td>
                      <button
                        className="button button-secondary"
                        type="button"
                        onClick={() => openEditModal(department)}
                      >
                        Edit
                      </button>
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {canManageDepartments && (
          <div className="card__footer">
            <button className="button button-secondary" type="button" onClick={openCreateModal}>
              {t('settings_departments_add')}
            </button>
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="modal-overlay" role="dialog" aria-modal="true">
          <div className="modal">
            <div className="card__header">
              <div>
                <p className="muted">{t('settings_departments_title')}</p>
                <h2 className="card__title">
                  {editingDepartment ? 'Edit department' : t('settings_departments_add')}
                </h2>
              </div>
              <button
                className="button button-secondary"
                type="button"
                onClick={() => setModalOpen(false)}
              >
                Close
              </button>
            </div>
            <form className="form" onSubmit={handleDepartmentSubmit}>
              <label className="form__label" htmlFor="departmentCode">
                Code
              </label>
              <input
                id="departmentCode"
                className="input"
                value={departmentForm.code}
                onChange={(event) =>
                  setDepartmentForm({ ...departmentForm, code: event.target.value })
                }
                required
              />

              <label className="form__label" htmlFor="departmentName">
                Name
              </label>
              <input
                id="departmentName"
                className="input"
                value={departmentForm.name}
                onChange={(event) =>
                  setDepartmentForm({ ...departmentForm, name: event.target.value })
                }
                required
              />

              <label className="form__label" htmlFor="departmentParent">
                Parent department
              </label>
              <select
                id="departmentParent"
                className="input"
                value={departmentForm.parent_id}
                onChange={(event) =>
                  setDepartmentForm({ ...departmentForm, parent_id: event.target.value })
                }
              >
                <option value="">—</option>
                {departments.map((dept) => (
                  <option key={dept.id} value={dept.id}>
                    {resolveDepartmentName(dept)}
                  </option>
                ))}
              </select>

              {canViewUsers && (
                <>
                  <label className="form__label" htmlFor="departmentManager">
                    Manager
                  </label>
                  <select
                    id="departmentManager"
                    className="input"
                    value={departmentForm.manager_user_id}
                    onChange={(event) =>
                      setDepartmentForm({
                        ...departmentForm,
                        manager_user_id: event.target.value
                      })
                    }
                  >
                    <option value="">—</option>
                    {users.map((user) => (
                      <option key={user.id} value={user.id}>
                        {user.email}
                      </option>
                    ))}
                  </select>
                </>
              )}

              <div className="form__actions">
                <button className="button button-primary" type="submit">
                  {editingDepartment ? 'Save changes' : t('settings_departments_add')}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

function RolesSection({ permissions }: { permissions: string[] }) {
  const { t } = useI18n();
  const [roleRows, setRoleRows] = useState<Role[]>([]);
  const [permissionRows, setPermissionRows] = useState<Permission[]>([]);

  useEffect(() => {
    const loadRoles = async () => {
      try {
        const [rolesData, permissionsData] = await Promise.all([
          fetchRoles(),
          fetchPermissions()
        ]);
        setRoleRows(rolesData);
        setPermissionRows(permissionsData);
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error('Failed to load roles data', err);
      }
    };

    loadRoles();
  }, []);

  if (!hasPermission('roles.view', permissions)) {
    return (
      <div className="card">
        <h2 className="card__title">{t('settings_access_denied_title')}</h2>
        <p className="muted">{t('settings_access_denied_body')}</p>
      </div>
    );
  }

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
              {roleRows.map((role) => (
                <tr key={role.code}>
                  <td>{role.code}</td>
                  <td>{t(role.name_key)}</td>
                  <td>
                    <span className="pill pill-muted">{role.permissions[0]?.scope || 'none'}</span>
                  </td>
                  <td>
                    <div className="tags">
                      {role.permissions.map((perm) => (
                        <span key={perm.code} className="tag">
                          {perm.code}
                        </span>
                      ))}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <div className="card">
        <div className="card__header">
          <div>
            <p className="muted">{t('settings_roles_label')}</p>
            <h2 className="card__title">{t('settings_permissions_title')}</h2>
          </div>
          <div className="pill">GET /api/core/v1/permissions</div>
        </div>
        <p className="muted">{t('settings_permissions_hint')}</p>
        <div className="tags">
          {permissionRows.map((perm) => (
            <span key={perm.code} className="tag">
              {perm.code}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

function LanguagesSection({
  permissions,
  onNotify
}: {
  permissions: string[];
  onNotify: (message: string, variant: Toast['variant']) => void;
}) {
  const { t, languages, defaultLanguage, translations, registerTranslation, refresh } = useI18n();
  const enabledCount = languages.filter((lang) => lang.is_active).length;
  const [languageForm, setLanguageForm] = useState({ code: '', name: '', is_default: false });
  const [translationForm, setTranslationForm] = useState({
    key: '',
    values: {} as Record<string, string>
  });
  const [saving, setSaving] = useState(false);
  const [rowSaving, setRowSaving] = useState<Record<string, boolean>>({});
  const [draftTranslations, setDraftTranslations] = useState<
    Record<string, Record<string, string>>
  >({});
  const canManageLanguages = hasPermission('i18n.languages.manage', permissions);
  const canViewTranslations = hasPermission('i18n.translations.view', permissions);
  const canManageTranslations = hasPermission('i18n.translations.manage', permissions);

  useEffect(() => {
    if (defaultLanguage) {
      setTranslationForm((prev) => ({
        ...prev,
        values: { ...prev.values, [defaultLanguage]: prev.values[defaultLanguage] ?? '' }
      }));
    }
  }, [defaultLanguage]);

  const translationRows = useMemo(() => {
    const keys = new Set<string>();
    Object.values(translations).forEach((entries) => {
      Object.keys(entries).forEach((key) => keys.add(key));
    });
    return Array.from(keys).sort().map((key) => ({
      key,
      values: languages.reduce<Record<string, string>>((acc, lang) => {
        acc[lang.code] = translations[lang.code]?.[key] ?? '';
        return acc;
      }, {})
    }));
  }, [translations, languages]);

  useEffect(() => {
    const nextDraft: Record<string, Record<string, string>> = {};
    translationRows.forEach((row) => {
      nextDraft[row.key] = { ...row.values };
    });
    setDraftTranslations(nextDraft);
  }, [translationRows]);

  const handleLanguageSubmit = async (event: FormEvent) => {
    event.preventDefault();
    if (!canManageLanguages) return;
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
      onNotify(t('settings_languages_form_submit'), 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleStatusToggle = async (lang: Language, active: boolean) => {
    if (!canManageLanguages) return;
    try {
      await updateLanguage(lang.code, { is_active: active });
      await refresh();
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  const handleDefaultToggle = async (lang: Language) => {
    if (!canManageLanguages) return;
    try {
      await updateLanguage(lang.code, { is_default: true, is_active: true });
      await refresh();
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    }
  };

  const handleTranslationSubmit = async () => {
    if (!canManageTranslations) return;
    setSaving(true);
    try {
      await registerTranslation(translationForm.key, translationForm.values);
      setTranslationForm({ key: '', values: {} });
      onNotify(t('settings_translations_form_submit'), 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleTranslationSave = async (key: string) => {
    if (!canManageTranslations) return;
    setRowSaving((prev) => ({ ...prev, [key]: true }));
    try {
      await registerTranslation(key, draftTranslations[key] || {});
      onNotify(t('settings_translations_form_submit'), 'success');
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      onNotify(message, 'error');
    } finally {
      setRowSaving((prev) => ({ ...prev, [key]: false }));
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
                    {canManageLanguages ? (
                      <label className="toggle">
                        <input
                          type="checkbox"
                          checked={lang.is_active}
                          onChange={(e) => handleStatusToggle(lang, e.target.checked)}
                        />
                        <span>{lang.is_active ? t('status_enabled') : t('status_disabled')}</span>
                      </label>
                    ) : (
                      <span>{lang.is_active ? t('status_enabled') : t('status_disabled')}</span>
                    )}
                  </td>
                  <td>
                    {canManageLanguages ? (
                      <label className="toggle">
                        <input
                          type="radio"
                          name="default-language"
                          checked={lang.is_default}
                          onChange={() => handleDefaultToggle(lang)}
                        />
                        <span>{lang.is_default ? t('status_yes') : t('status_no')}</span>
                      </label>
                    ) : (
                      <span>{lang.is_default ? t('status_yes') : t('status_no')}</span>
                    )}
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

      {canManageLanguages && (
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
                onChange={(e) =>
                  setLanguageForm({ ...languageForm, is_default: e.target.checked })
                }
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
      )}

      {!canViewTranslations ? (
        <div className="card">
          <h2 className="card__title">{t('settings_access_denied_title')}</h2>
          <p className="muted">{t('settings_access_denied_body')}</p>
        </div>
      ) : (
        <div className="card">
          <div className="card__header">
            <div>
              <p className="muted">{t('settings_languages_label')}</p>
              <h2 className="card__title">{t('settings_translations_title')}</h2>
            </div>
            <div className="pill">/api/core/v1/i18n/translations</div>
          </div>
          <div className="table-wrapper">
            <table className="table">
              <thead>
                <tr>
                  <th>{t('settings_translations_key')}</th>
                  {languages.map((lang) => (
                    <th key={lang.code}>{lang.code.toUpperCase()}</th>
                  ))}
                  {canManageTranslations && <th>Actions</th>}
                </tr>
              </thead>
              <tbody>
                {canManageTranslations && (
                  <tr>
                    <td>
                      <input
                        className="input"
                        value={translationForm.key}
                        onChange={(e) =>
                          setTranslationForm({ ...translationForm, key: e.target.value })
                        }
                        placeholder={t('settings_translations_form_key')}
                      />
                    </td>
                    {languages.map((lang) => (
                      <td key={lang.code}>
                        <input
                          className="input"
                          value={translationForm.values[lang.code] || ''}
                          onChange={(e) =>
                            setTranslationForm({
                              ...translationForm,
                              values: {
                                ...translationForm.values,
                                [lang.code]: e.target.value
                              }
                            })
                          }
                          placeholder={lang.name}
                        />
                      </td>
                    ))}
                    <td>
                      <button
                        className="button button-primary"
                        type="button"
                        onClick={handleTranslationSubmit}
                        disabled={saving || !translationForm.key}
                      >
                        {t('settings_translations_form_submit')}
                      </button>
                    </td>
                  </tr>
                )}
                {translationRows.map((row) => (
                  <tr key={row.key}>
                    <td>{row.key}</td>
                    {languages.map((lang) => (
                      <td key={lang.code}>
                        {canManageTranslations ? (
                          <input
                            className="input"
                            value={draftTranslations[row.key]?.[lang.code] ?? ''}
                            onChange={(e) =>
                              setDraftTranslations((prev) => ({
                                ...prev,
                                [row.key]: {
                                  ...(prev[row.key] || {}),
                                  [lang.code]: e.target.value
                                }
                              }))
                            }
                          />
                        ) : (
                          <span>{draftTranslations[row.key]?.[lang.code] ?? ''}</span>
                        )}
                      </td>
                    ))}
                    {canManageTranslations && (
                      <td>
                        <button
                          className="button button-secondary"
                          type="button"
                          onClick={() => handleTranslationSave(row.key)}
                          disabled={rowSaving[row.key]}
                        >
                          {t('settings_translations_form_submit')}
                        </button>
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}

function AuditSection({
  permissions,
  onNotify
}: {
  permissions: string[];
  onNotify: (message: string, variant: Toast['variant']) => void;
}) {
  const { t } = useI18n();
  const canViewAudit = hasPermission('audit.view', permissions);
  const [filters, setFilters] = useState({
    from: '',
    to: '',
    event: '',
    q: '',
    limit: 10,
    page: 1
  });
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [selectedLog, setSelectedLog] = useState<AuditLog | null>(null);

  useEffect(() => {
    if (!canViewAudit) return;
    const loadAudit = async () => {
      setLoading(true);
      try {
        const data = await fetchAuditLogs({
          from: filters.from,
          to: filters.to,
          event: filters.event,
          q: filters.q,
          limit: filters.limit,
          page: filters.page
        });
        setLogs(data.logs);
        setTotal(data.total ?? data.logs.length);
        setSelectedLog(data.logs[0] || null);
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        onNotify(message, 'error');
      } finally {
        setLoading(false);
      }
    };

    loadAudit();
  }, [canViewAudit, filters, onNotify]);

  useEffect(() => {
    setFilters((prev) => ({ ...prev, page: 1 }));
  }, [filters.from, filters.to, filters.event, filters.q, filters.limit]);

  if (!canViewAudit) {
    return (
      <div className="card">
        <h2 className="card__title">{t('settings_access_denied_title')}</h2>
        <p className="muted">{t('settings_access_denied_body')}</p>
      </div>
    );
  }

  const totalPages = Math.max(1, Math.ceil((total || logs.length) / filters.limit));

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
              {Array.from(new Set(logs.map((log) => log.event_type || log.event || '')))
                .filter(Boolean)
                .map((event) => (
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
              {loading && (
                <tr>
                  <td colSpan={5} className="muted">
                    Loading...
                  </td>
                </tr>
              )}
              {!loading && logs.length === 0 && (
                <tr>
                  <td colSpan={5} className="muted">
                    No audit logs found.
                  </td>
                </tr>
              )}
              {logs.map((log) => (
                <tr key={log.id} className={selectedLog?.id === log.id ? 'is-selected' : ''}>
                  <td>{new Date(log.created_at).toLocaleString()}</td>
                  <td>{log.event_type || log.event}</td>
                  <td>{log.user || log.actor?.email || '—'}</td>
                  <td>{
                    log.entity ||
                    (log.entity_type ? `${log.entity_type}${log.entity_id ? `:${log.entity_id}` : ''}` : '—')
                  }</td>
                  <td>
                    <button
                      className="button button-ghost"
                      type="button"
                      onClick={() => setSelectedLog(log)}
                    >
                      {JSON.stringify(log.payload || {}).slice(0, 60)}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="pagination">
          <div>{t('settings_audit_page', { page: filters.page, total: totalPages })}</div>
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
              onClick={() =>
                setFilters({ ...filters, page: Math.min(totalPages, filters.page + 1) })
              }
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
              <h2 className="card__title">{selectedLog.event_type || selectedLog.event}</h2>
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
