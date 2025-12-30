import { createContext, useEffect, useMemo, useState } from 'react';
import { Navigate, Route, Routes, useLocation, useNavigate } from 'react-router-dom';
import AuthGuard from './AuthGuard';
import Shell from '../layout/Shell';
import Login from '../pages/Login';
import Settings from '../pages/Settings';
import { User, fetchCurrentUser, tokenStore } from './api';

export type AuthContextValue = {
  user: User | null;
  setUser: (user: User | null) => void;
  setToken: (token: string | null) => void;
};

export const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export default function App() {
  const [user, setUser] = useState<User | null>(null);
  const [booting, setBooting] = useState(true);
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = () => {
    tokenStore.clear();
    setUser(null);
    if (location.pathname !== '/login') {
      navigate('/login', { replace: true });
    }
  };

  useEffect(() => {
    const token = tokenStore.get();
    if (!token) {
      setBooting(false);
      return;
    }

    fetchCurrentUser()
      .then((currentUser) => {
        setUser(currentUser);
      })
      .catch(() => {
        handleLogout();
      })
      .finally(() => setBooting(false));
  }, []);

  const contextValue = useMemo(
    () => ({
      user,
      setUser,
      setToken: (token: string | null) => {
        if (token) {
          tokenStore.set(token);
        } else {
          tokenStore.clear();
        }
      }
    }),
    [user]
  );

  if (booting) {
    return (
      <div className="page page-centered">
        <div className="card">
          <div className="loading-dot" />
          <p className="muted">Загрузка...</p>
        </div>
      </div>
    );
  }

  return (
    <AuthContext.Provider value={contextValue}>
      <Routes>
        <Route path="/login" element={<Login onAuthenticated={() => navigate('/settings', { replace: true })} />} />
        <Route element={<AuthGuard user={user} onLogout={handleLogout} />}>
          <Route element={<Shell user={user} onLogout={handleLogout} />}>
            <Route path="/settings" element={<Settings />} />
            <Route path="/" element={<Navigate to="/settings" replace />} />
          </Route>
        </Route>
        <Route path="*" element={<Navigate to={user ? '/settings' : '/login'} replace />} />
      </Routes>
    </AuthContext.Provider>
  );
}
