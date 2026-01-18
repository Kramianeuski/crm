import { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { useI18n } from '../app/i18n';

const settingsItems = [
  { labelKey: 'settings_nav_system', to: '/settings#system' },
  { labelKey: 'settings_nav_roles', to: '/settings#roles' },
  { labelKey: 'settings_nav_languages', to: '/settings#languages' }
];

export default function Sidebar() {
  const { t } = useI18n();
  const [settingsOpen, setSettingsOpen] = useState(true);
  return (
    <aside className="sidebar">
      <nav className="sidebar__nav">
        <div className="nav-group">
          <button
            className={`nav-link nav-link--toggle ${settingsOpen ? 'is-open' : ''}`}
            type="button"
            onClick={() => setSettingsOpen((prev) => !prev)}
          >
            {t('sidebar_settings')}
          </button>
          {settingsOpen && (
            <div className="nav-group__items">
              {settingsItems.map((item) => (
                <NavLink
                  key={item.to}
                  to={item.to}
                  className={({ isActive }) =>
                    `nav-link nav-link--child ${isActive ? 'is-active' : ''}`
                  }
                >
                  {t(item.labelKey)}
                </NavLink>
              ))}
            </div>
          )}
        </div>
      </nav>
    </aside>
  );
}
