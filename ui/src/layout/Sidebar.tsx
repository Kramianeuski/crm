import { NavLink } from 'react-router-dom';

const navItems = [
  { label: 'Settings', to: '/settings' }
];

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <nav className="sidebar__nav">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) => `nav-link ${isActive ? 'is-active' : ''}`}
          >
            {item.label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
