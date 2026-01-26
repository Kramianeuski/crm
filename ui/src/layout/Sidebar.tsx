import { useContext, useEffect, useMemo, useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { AuthContext } from '../app/App';
import { useI18n } from '../app/i18n';
import { NAV_GROUPS } from '../app/navigation';

type Props = {
  open: boolean;
  onClose: () => void;
};

const NAV_STATE_KEY = 'crm_nav_state';

function hasPermission(permission: string, granted: string[]): boolean {
  return granted.includes(permission);
}

export default function Sidebar({ open, onClose }: Props) {
  const { t } = useI18n();
  const auth = useContext(AuthContext);
  const permissions = auth?.user?.permissions ?? [];
  const location = useLocation();
  const currentPath = `${location.pathname}${location.hash}`;
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>(() => {
    const stored = localStorage.getItem(NAV_STATE_KEY);
    if (stored) {
      try {
        return JSON.parse(stored) as Record<string, boolean>;
      } catch (err) {
        console.warn('Failed to parse navigation state', err);
      }
    }
    const initialGroups = Object.fromEntries(NAV_GROUPS.map((group) => [group.key, true]));
    const initialSections = Object.fromEntries(
      NAV_GROUPS.flatMap((group) => group.sections.map((section) => [section.key, true]))
    );
    return { ...initialGroups, ...initialSections };
  });

  const groups = useMemo(
    () =>
      NAV_GROUPS.map((group) => ({
        ...group,
        sections: group.sections
          .map((section) => ({
            ...section,
            items: section.items.filter((item) => hasPermission(item.permission, permissions))
          }))
          .filter((section) => section.items.length > 0)
      })).filter((group) => group.sections.length > 0),
    [permissions]
  );

  useEffect(() => {
    localStorage.setItem(NAV_STATE_KEY, JSON.stringify(openGroups));
  }, [openGroups]);

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
                  {group.sections.map((section) => {
                    const sectionOpen = openGroups[section.key];
                    return (
                      <div key={section.key} className="nav-section">
                        <button
                          className={`nav-link nav-link--section ${sectionOpen ? 'is-open' : ''}`}
                          type="button"
                          onClick={() =>
                            setOpenGroups((prev) => ({
                              ...prev,
                              [section.key]: !prev[section.key]
                            }))
                          }
                        >
                          {t(section.labelKey)}
                        </button>
                        {sectionOpen && (
                          <div className="nav-section__items">
                            {section.items.map((item) => (
                              <NavLink
                                key={item.key}
                                to={item.path}
                                className={() =>
                                  `nav-link nav-link--child ${
                                    currentPath === item.path ? 'is-active' : ''
                                  }`
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
                </div>
              )}
            </div>
          );
        })}
      </nav>
    </aside>
  );
}
