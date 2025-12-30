import { User } from '../app/api';

type Props = {
  user: User | null;
  onLogout: () => void;
};

export default function Header({ user, onLogout }: Props) {
  return (
    <header className="header">
      <div className="header__brand">
        <div className="logo-mark">CRM</div>
        <div>
          <p className="brand-title">SISSOL CRM</p>
          <p className="muted">Core interface</p>
        </div>
      </div>
      <div className="header__actions">
        <div className="user-badge">
          <div className="user-avatar">{user?.email?.[0]?.toUpperCase() || '?'}</div>
          <div>
            <p className="user-email">{user?.email}</p>
            <p className="muted">Online</p>
          </div>
        </div>
        <button className="button button-secondary" onClick={onLogout}>
          Logout
        </button>
      </div>
    </header>
  );
}
