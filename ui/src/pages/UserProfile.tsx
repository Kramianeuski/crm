import { FormEvent, useContext, useEffect, useState } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { AuthContext } from '../app/App';
import { useI18n } from '../app/i18n';
import { Role, UserDetail, deleteUser, fetchRoles, fetchUser, updateUser } from '../app/api';

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

export default function UserProfile() {
  const { t, languages } = useI18n();
  const auth = useContext(AuthContext);
  const navigate = useNavigate();
  const location = useLocation();
  const { id } = useParams();
  const isEdit = location.pathname.endsWith('/edit');
  const permissions = auth?.user?.permissions ?? [];
  const canViewUsers = hasPermission('users.view', permissions);
  const canManageUsers = hasPermission('users.manage', permissions);
  const canAssignRoles = hasPermission('users.roles.assign', permissions);
  const [user, setUser] = useState<UserDetail | null>(null);
  const [draft, setDraft] = useState<UserDetail | null>(null);
  const [roles, setRoles] = useState<Role[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);

  useEffect(() => {
    if (!canViewUsers || !id) return;
    const loadUser = async () => {
      setLoading(true);
      try {
        const data = await fetchUser(id);
        setUser(data);
        setDraft(data);
      } catch (err) {
        setUser(null);
      } finally {
        setLoading(false);
      }
    };
    loadUser();
  }, [canViewUsers, id]);

  useEffect(() => {
    if (!canAssignRoles) return;
    const loadRoles = async () => {
      const data = await fetchRoles();
      setRoles(data);
    };
    loadRoles();
  }, [canAssignRoles]);

  const handleSave = async (event: FormEvent) => {
    event.preventDefault();
    if (!draft || !user) return;
    if (!canManageUsers && !canAssignRoles) return;
    setSaving(true);
    try {
      const payload: Partial<UserDetail> = {
        first_name: draft.first_name ?? null,
        last_name: draft.last_name ?? null,
        company_name: draft.company_name ?? null,
        lang: draft.lang ?? null,
        is_active: draft.is_active,
        roles: draft.roles
      };
      const updated = await updateUser(String(user.id), payload);
      setUser(updated);
      setDraft(updated);
      navigate(`/users/${user.id}`, { replace: true });
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!user || !canManageUsers) return;
    setSaving(true);
    try {
      await deleteUser(String(user.id));
      navigate('/settings#users-list', { replace: true });
    } finally {
      setSaving(false);
    }
  };

  if (!canViewUsers) {
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
    <div className="page">
      <div className="page__header">
        <div>
          <p className="muted">{t('settings_users_label')}</p>
          <h1 className="page__title">{user?.email || t('settings_users_title')}</h1>
        </div>
        <div className="actions-row">
          <button
            className="button button-secondary"
            type="button"
            onClick={() => navigate('/settings#users-list')}
          >
            Back to list
          </button>
          {!isEdit && canManageUsers && user && (
            <button
              className="button button-primary"
              type="button"
              onClick={() => navigate(`/users/${user.id}/edit`)}
            >
              Edit
            </button>
          )}
          {canManageUsers && (
            <button className="button button-ghost" type="button" onClick={() => setConfirmDelete(true)}>
              Delete
            </button>
          )}
        </div>
      </div>

      {loading && (
        <div className="card">
          <p className="muted">Loading...</p>
        </div>
      )}

      {!loading && user && draft && (
        <div className="stack">
          <div className="card">
            <div className="card__header">
              <div>
                <p className="muted">{t('settings_users_label')}</p>
                <h2 className="card__title">{isEdit ? 'Edit user' : 'User profile'}</h2>
              </div>
              <div className="pill">{isEdit ? 'PUT /api/core/v1/users/:id' : 'GET /api/core/v1/users/:id'}</div>
            </div>

            {isEdit ? (
              <form className="form two-column" onSubmit={handleSave}>
                <ReadOnlyField label={t('settings_users_email')} value={user.email} />

                <label className="form__label" htmlFor="userFirstName">
                  {t('settings_users_first_name')}
                </label>
                <input
                  id="userFirstName"
                  className="input"
                  value={draft.first_name || ''}
                  onChange={(event) => setDraft({ ...draft, first_name: event.target.value })}
                />

                <label className="form__label" htmlFor="userLastName">
                  {t('settings_users_last_name')}
                </label>
                <input
                  id="userLastName"
                  className="input"
                  value={draft.last_name || ''}
                  onChange={(event) => setDraft({ ...draft, last_name: event.target.value })}
                />

                <label className="form__label" htmlFor="userCompany">
                  {t('settings_users_company')}
                </label>
                <input
                  id="userCompany"
                  className="input"
                  value={draft.company_name || ''}
                  onChange={(event) => setDraft({ ...draft, company_name: event.target.value })}
                />

                <label className="form__label" htmlFor="userLang">
                  {t('settings_users_language')}
                </label>
                <select
                  id="userLang"
                  className="input"
                  value={draft.lang || ''}
                  onChange={(event) => setDraft({ ...draft, lang: event.target.value })}
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
                    checked={!!draft.is_active}
                    onChange={(event) => setDraft({ ...draft, is_active: event.target.checked })}
                  />
                  <span>{draft.is_active ? t('status_active') : t('status_inactive')}</span>
                </label>

                {(canManageUsers || canAssignRoles) && (
                  <div className="form__actions">
                    <button className="button button-primary" type="submit" disabled={saving}>
                      Save
                    </button>
                  </div>
                )}
              </form>
            ) : (
              <div className="read-only-grid">
                <ReadOnlyField label={t('settings_users_email')} value={user.email} />
                <ReadOnlyField label={t('settings_users_first_name')} value={user.first_name || '—'} />
                <ReadOnlyField label={t('settings_users_last_name')} value={user.last_name || '—'} />
                <ReadOnlyField label={t('settings_users_company')} value={user.company_name || '—'} />
                <ReadOnlyField label={t('settings_users_language')} value={user.lang || '—'} />
                <ReadOnlyField
                  label={t('settings_users_status')}
                  value={user.is_active ? t('status_active') : t('status_inactive')}
                />
              </div>
            )}
          </div>

          {canAssignRoles && (
            <div className="card">
              <div className="card__header">
                <div>
                  <p className="muted">{t('settings_users_roles')}</p>
                  <h2 className="card__title">{isEdit ? 'Assign roles' : 'Roles'}</h2>
                </div>
              </div>
              <div className="tags">
                {roles.map((role) => {
                  const isChecked = (draft.roles || []).includes(role.code);
                  return (
                    <label key={role.code} className="tag tag-selectable">
                      <input
                        type="checkbox"
                        disabled={!isEdit}
                        checked={isChecked}
                        onChange={(event) => {
                          if (!draft) return;
                          const nextRoles = new Set(draft.roles || []);
                          if (event.target.checked) {
                            nextRoles.add(role.code);
                          } else {
                            nextRoles.delete(role.code);
                          }
                          setDraft({ ...draft, roles: Array.from(nextRoles) });
                        }}
                      />
                      <span>{role.code}</span>
                    </label>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      )}

      {!loading && !user && (
        <div className="card">
          <p className="muted">User not found.</p>
        </div>
      )}

      {confirmDelete && (
        <div className="modal-overlay" role="dialog" aria-modal="true">
          <div className="modal">
            <div className="card__header">
              <div>
                <p className="muted">{t('settings_users_label')}</p>
                <h2 className="card__title">Confirm delete</h2>
              </div>
              <button className="button button-secondary" type="button" onClick={() => setConfirmDelete(false)}>
                Close
              </button>
            </div>
            <p className="muted">This action cannot be undone.</p>
            <div className="drawer__footer">
              <button className="button button-secondary" type="button" onClick={() => setConfirmDelete(false)}>
                Cancel
              </button>
              <button className="button button-primary" type="button" onClick={handleDelete} disabled={saving}>
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
