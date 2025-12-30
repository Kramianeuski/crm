import { Outlet } from 'react-router-dom';
import { User } from '../app/api';
import Header from './Header';
import Sidebar from './Sidebar';

type Props = {
  user: User | null;
  onLogout: () => void;
};

export default function Shell({ user, onLogout }: Props) {
  return (
    <div className="app-shell">
      <Header user={user} onLogout={onLogout} />
      <div className="app-shell__body">
        <Sidebar />
        <main className="app-shell__content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
