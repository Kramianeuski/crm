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
  const [sidebarOpen, setSidebarOpen] = useState(true);
  return (
    <div className={`app-shell ${sidebarOpen ? 'is-sidebar-open' : 'is-sidebar-collapsed'}`}>
      <Header
        user={user}
        onLogout={onLogout}
        onToggleSidebar={() => setSidebarOpen((prev) => !prev)}
        sidebarOpen={sidebarOpen}
      />
      <div className="app-shell__body">
        <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
        {sidebarOpen && <button className="sidebar-backdrop" type="button" onClick={() => setSidebarOpen(false)} />}
        <main className="app-shell__content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
