import { User } from '../app/api';
import { useI18n } from '../app/i18n';

type Props = {
  user: User | null;
  onLogout: () => void;
  onToggleSidebar: () => void;
  sidebarOpen: boolean;
};

export default function Header({ user, onLogout, onToggleSidebar, sidebarOpen }: Props) {
  const { t, language, languages, setLanguage } = useI18n();
  const activeLanguages = languages.filter((lang) => lang.is_active);

  return (
    <header className="header">
      <div className="header__brand">
        <button
          className="button button-secondary header__toggle"
          type="button"
          onClick={onToggleSidebar}
          aria-label="Toggle navigation"
        >
          {sidebarOpen ? '☰' : '☰'}
        </button>
        <div className="logo-mark">CRM</div>
        <div>
          <p className="brand-title">{t('layout_brand_title')}</p>
          <p className="muted">{t('layout_brand_subtitle')}</p>
        </div>
      </div>
      <div className="header__actions">
        <div className="user-badge">
          <div className="user-avatar">{user?.email?.[0]?.toUpperCase() || '?'}</div>
          <div>
            <p className="user-email">{user?.email}</p>
            <p className="muted">{t('layout_status_online')}</p>
          </div>
        </div>
        {activeLanguages.length > 0 && (
          <label className="select">
            <span className="muted select__label">{t('app_language_selector_label')}</span>
            <select
              className="input"
              value={language}
              onChange={(event) => setLanguage(event.target.value)}
            >
              {activeLanguages.map((lang) => (
                <option key={lang.code} value={lang.code}>
                  {lang.name}
                </option>
              ))}
            </select>
          </label>
        )}
        <button className="button button-secondary" onClick={onLogout}>
          {t('layout_action_logout')}
        </button>
      </div>
    </header>
  );
}
