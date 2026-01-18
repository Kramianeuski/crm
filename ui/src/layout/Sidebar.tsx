import { useContext, useState } from 'react';
import { NavLink } from 'react-router-dom';
import { AuthContext } from '../app/App';
import { useI18n } from '../app/i18n';
import { NAV_GROUPS } from '../app/navigation';

type Props = {
  open: boolean;
  onClose: () => void;
};

function hasPermission(permission: string, granted: string[]): boolean {
  return granted.includes(permission);
}

export default function Sidebar({ open, onClose }: Props) {
  const { t } = useI18n();
  const auth = useContext(AuthContext);
  const permissions = auth?.user?.permissions ?? [];
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>(() =>
    Object.fromEntries(NAV_GROUPS.map((group) => [group.key, true]))
  );

  const groups = NAV_GROUPS.map((group) => ({
    ...group,
    items: group.items.filter((item) => hasPermission(item.permission, permissions))
  })).filter((group) => group.items.length > 0);

  if (groups.length === 0) {
    return null;
  }

  return (
    <aside className={`sidebar ${open ? 'is-open' : 'is-closed'}`}>
      <nav className="sidebar__nav">
        {groups.map((group) => {
          const isOpen = openGroups[group.key];
          return (
            <div key={group.key} className="nav-group">
              <button
                className={`nav-link nav-link--toggle ${isOpen ? 'is-open' : ''}`}
                type="button"
                onClick={() =>
                  setOpenGroups((prev) => ({ ...prev, [group.key]: !prev[group.key] }))
                }
              >
                {t(group.labelKey)}
              </button>
              {isOpen && (
                <div className="nav-group__items">
                  {group.items.map((item) => (
                    <NavLink
                      key={item.key}
                      to={`/settings#${item.key}`}
                      className={({ isActive }) =>
                        `nav-link nav-link--child ${isActive ? 'is-active' : ''}`
                      }
                      onClick={onClose}
                    >
                      {t(item.labelKey)}
                    </NavLink>
                  ))}
                </div>
              )}
            </div>
          );
        })}
      </nav>
    </aside>
  );
}
