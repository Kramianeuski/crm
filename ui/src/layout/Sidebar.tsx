import { NavLink } from 'react-router-dom';
import { useI18n } from '../app/i18n';

const navItems = [
  { labelKey: 'sidebar_settings', to: '/settings' }
];

export default function Sidebar() {
  const { t } = useI18n();
  return (
    <aside className="sidebar">
      <nav className="sidebar__nav">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) => `nav-link ${isActive ? 'is-active' : ''}`}
          >
            {t(item.labelKey)}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
