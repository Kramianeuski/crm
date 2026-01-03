import { FormEvent, useContext, useState } from 'react';
import { AuthContext } from '../app/App';
import { fetchCurrentUser, login as performLogin } from '../app/api';
import { useI18n } from '../app/i18n';

type Props = {
  onAuthenticated: () => void;
};

export default function Login({ onAuthenticated }: Props) {
  const auth = useContext(AuthContext);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const { t } = useI18n();

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
      const code = err instanceof Error && 'code' in err && err.code ? (err as any).code : err instanceof Error ? err.message : '';
      const key =
        code === 'invalid_credentials'
          ? 'auth_error_invalid_credentials'
          : code === 'invalid_request'
            ? 'auth_error_invalid_request'
            : 'auth_error_generic';
      setError(t(key));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page page-centered">
      <div className="card card-auth">
        <div className="logo-mark">CRM</div>
        <h1 className="brand-title">{t('layout_brand_title')}</h1>
        <p className="muted">{t('auth_subtitle')}</p>
        <form className="form" onSubmit={handleSubmit}>
          <label className="form__label" htmlFor="email">
            {t('auth_email_label')}
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
            placeholder={t('auth_email_placeholder')}
          />

          <label className="form__label" htmlFor="password">
            {t('auth_password_label')}
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
            placeholder={t('auth_password_placeholder')}
          />

          {error && <div className="alert">{error}</div>}

          <button className="button button-primary" type="submit" disabled={loading}>
            {loading ? t('auth_button_loading') : t('auth_button_idle')}
          </button>
        </form>
      </div>
    </div>
  );
}
