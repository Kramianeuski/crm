import { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { User } from '../app/api';
import Header from './Header';
import Sidebar from './Sidebar';

type Props = {
  user: User | null;
  onLogout: () => void;
};

export default function Shell({ user, onLogout }: Props) {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  return (
    <div className={`app-shell ${sidebarCollapsed ? 'is-sidebar-collapsed' : 'is-sidebar-open'}`}>
      <Header
        user={user}
        onLogout={onLogout}
        onToggleSidebar={() => setSidebarCollapsed((prev) => !prev)}
        sidebarOpen={!sidebarCollapsed}
      />
      <div className="app-shell__body">
        <Sidebar collapsed={sidebarCollapsed} />
        <main className="app-shell__content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
