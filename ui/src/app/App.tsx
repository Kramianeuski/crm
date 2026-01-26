import { createContext, useEffect, useMemo, useState } from 'react';
import { Navigate, Route, Routes, useLocation, useNavigate } from 'react-router-dom';
import AuthGuard from './AuthGuard';
import Shell from '../layout/Shell';
import Login from '../pages/Login';
import Settings from '../pages/Settings';
import UserProfile from '../pages/UserProfile';
import { User, fetchCurrentUser, tokenStore } from './api';
import { I18nProvider, useI18n } from './i18n';

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

  return (
    <I18nProvider userLanguage={user?.lang}>
      <AppContent
        booting={booting}
        onAuthenticated={() => navigate('/settings', { replace: true })}
        onLogout={handleLogout}
        contextValue={contextValue}
        user={user}
      />
    </I18nProvider>
  );
}

type AppContentProps = {
  booting: boolean;
  onAuthenticated: () => void;
  onLogout: () => void;
  contextValue: AuthContextValue;
  user: User | null;
};

function AppContent({ booting, onAuthenticated, onLogout, contextValue, user }: AppContentProps) {
  const { t, loading: i18nLoading } = useI18n();

  if (booting || i18nLoading) {
    return (
      <div className="page page-centered">
        <div className="card">
          <div className="loading-dot" />
          <p className="muted">{t('app_loading')}</p>
        </div>
      </div>
    );
  }

  return (
    <AuthContext.Provider value={contextValue}>
      <Routes>
        <Route path="/login" element={<Login onAuthenticated={onAuthenticated} />} />
        <Route element={<AuthGuard user={user} onLogout={onLogout} />}>
          <Route element={<Shell user={user} onLogout={onLogout} />}>
            <Route path="/settings" element={<Settings />} />
            <Route path="/users/:id" element={<UserProfile />} />
            <Route path="/users/:id/edit" element={<UserProfile />} />
            <Route path="/" element={<Navigate to="/settings" replace />} />
          </Route>
        </Route>
        <Route path="*" element={<Navigate to={user ? '/settings' : '/login'} replace />} />
      </Routes>
    </AuthContext.Provider>
  );
}
