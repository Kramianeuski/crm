import { FormEvent, useContext, useState } from 'react';
import { AuthContext } from '../app/App';
import { fetchCurrentUser, login as performLogin } from '../app/api';

type Props = {
  onAuthenticated: () => void;
};

export default function Login({ onAuthenticated }: Props) {
  const auth = useContext(AuthContext);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!auth) {
    throw new Error('AuthContext not available');
  }

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await performLogin(email, password);
      const currentUser = await fetchCurrentUser();
      auth.setUser(currentUser);
      onAuthenticated();
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Ошибка авторизации';
      const friendly =
        message === 'invalid_credentials'
          ? 'Неверный email или пароль'
          : message === 'invalid_request'
            ? 'Введите email и пароль'
            : message;
      setError(friendly || 'Ошибка авторизации');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page page-centered">
      <div className="card card-auth">
        <div className="logo-mark">CRM</div>
        <h1 className="brand-title">SISSOL CRM</h1>
        <p className="muted">Войдите, чтобы продолжить</p>
        <form className="form" onSubmit={handleSubmit}>
          <label className="form__label" htmlFor="email">
            Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            className="input"
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            placeholder="you@example.com"
          />

          <label className="form__label" htmlFor="password">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            className="input"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            placeholder="••••••••"
          />

          {error && <div className="alert">{error}</div>}

          <button className="button button-primary" type="submit" disabled={loading}>
            {loading ? 'Вход...' : 'Войти'}
          </button>
        </form>
      </div>
    </div>
  );
}
