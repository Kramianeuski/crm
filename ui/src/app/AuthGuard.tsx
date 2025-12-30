import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { User } from './api';

type Props = {
  user: User | null;
  onLogout: () => void;
};

export default function AuthGuard({ user, onLogout }: Props) {
  const location = useLocation();

  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  if (!user.email) {
    onLogout();
    return <Navigate to="/login" replace />;
  }

  return <Outlet />;
}
