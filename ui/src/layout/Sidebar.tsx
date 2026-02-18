import { useEffect, useMemo, useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useI18n } from '../app/i18n';
import { NavigationItem, fetchNavigation } from '../app/api';

type Props = {
  collapsed: boolean;
};

const NAV_STATE_KEY = 'crm_nav_state';

const ICON_MAP: Record<string, string> = {
  settings: '⚙️',
  box: '📦',
  products: '📦',
  warehouse: '🏬',
  users: '👥',
  audit: '🧾',
  languages: '🌐'
};

function resolveIcon(icon?: string | null): string {
  if (!icon) return '•';
  const trimmed = icon.trim();
  return ICON_MAP[trimmed] || trimmed.slice(0, 1).toUpperCase();
}

function resolveLabel(
  t: (key: string) => string,
  item: Pick<NavigationItem, 'title' | 'title_key'>
): string {
  const fallbackByKey: Record<string, string> = {
    'settings.products': 'Товары',
    'settings.products.catalog': 'Каталог',
    'settings.products.attributes': 'Атрибуты',
    'settings.warehouse': 'Склад',
    'settings.warehouse.list': 'Склады'
  };

  if (item.title_key) {
    const translated = t(item.title_key);
    if (
      translated &&
      !translated.startsWith('[missing:') &&
      translated !== item.title_key
    ) {
      return translated;
    }

    if (fallbackByKey[item.title_key]) {
      return fallbackByKey[item.title_key];
    }
  }

  if (fallbackByKey[item.title]) {
    return fallbackByKey[item.title];
  }

  return item.title;
}

function normalizeRoute(route: string): string {
  if (route === '/settings/system') {
    return '/settings';
  }

  return route;
}

export default function Sidebar({ collapsed }: Props) {
  const { t } = useI18n();
  const location = useLocation();
  const currentPath = `${location.pathname}${location.hash}`;
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>({});
  const [navigation, setNavigation] = useState<NavigationItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [navigationError, setNavigationError] = useState<string | null>(null);
  const [reloadTick, setReloadTick] = useState(0);

  useEffect(() => {
    let isMounted = true;
    setLoading(true);

    fetchNavigation()
      .then((data) => {
        if (!isMounted) return;
        setNavigation(data);
        setNavigationError(null);
      })
      .catch((err) => {
        if (!isMounted) return;
        setNavigationError(err?.message || 'Не удалось загрузить меню');
        setNavigation([]);
        // eslint-disable-next-line no-console
        console.error('Failed to load navigation', err);
      })
      .finally(() => {
        if (!isMounted) return;
        setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [reloadTick]);

  useEffect(() => {
    if (navigation.length === 0) return;
    const stored = localStorage.getItem(NAV_STATE_KEY);
    let parsed: Record<string, boolean> = {};
    if (stored) {
      try {
        parsed = JSON.parse(stored) as Record<string, boolean>;
      } catch (err) {
        console.warn('Failed to parse navigation state', err);
      }
    }
    const initialGroups = Object.fromEntries(navigation.map((group) => [group.code, true]));
    setOpenGroups((prev) => ({
      ...initialGroups,
      ...parsed,
      ...prev
    }));
  }, [navigation]);

  useEffect(() => {
    localStorage.setItem(NAV_STATE_KEY, JSON.stringify(openGroups));
  }, [openGroups]);

  const groups = useMemo(() => navigation, [navigation]);

  return (
    <aside className="sidebar" data-collapsed={collapsed}>
      <nav className="sidebar__nav">
        <NavLink
          to="/settings"
          className={() =>
            `nav-link nav-link--child ${currentPath.startsWith('/settings') ? 'is-active' : ''}`
          }
        >
          <span className="nav-link__icon nav-link__icon--child" aria-hidden="true">
            •
          </span>
          <span className="nav-link__label">{t('settings_nav_system')}</span>
          <span className="nav-link__hover">{t('settings_nav_system')}</span>
        </NavLink>

        {navigationError && (
          <div className="card" style={{ margin: '8px 8px 12px', padding: '10px' }}>
            <p className="muted" style={{ marginBottom: 8 }}>
              {navigationError}
            </p>
            <button
              type="button"
              className="button button-secondary"
              onClick={() => setReloadTick((v) => v + 1)}
            >
              Повторить
            </button>
          </div>
        )}

        {!loading && !navigationError && groups.length === 0 && (
          <div className="card" style={{ margin: '8px 8px 12px', padding: '10px' }}>
            <p className="muted">Меню пустое. Проверьте права доступа.</p>
          </div>
        )}

        {groups.map((group) => {
          const isOpen = openGroups[group.code];
          const groupLabel = resolveLabel(t, group);
          return (
            <div key={group.code} className="nav-group">
              <button
                className={`nav-link nav-link--toggle ${isOpen ? 'is-open' : ''}`}
                type="button"
                onClick={() =>
                  setOpenGroups((prev) => ({ ...prev, [group.code]: !prev[group.code] }))
                }
              >
                <span className="nav-link__icon" aria-hidden="true">
                  {resolveIcon(group.icon)}
                </span>
                <span className="nav-link__label">{groupLabel}</span>
                <span className="nav-link__hover">{groupLabel}</span>
              </button>
              {isOpen && (
                <div className="nav-group__items">
                  {group.children?.map((item) => {
                    const itemLabel = resolveLabel(t, item);
                    const route = normalizeRoute(item.route);
                    return (
                      <NavLink
                        key={item.code}
                        to={route}
                        className={() =>
                          `nav-link nav-link--child ${
                            currentPath === route ? 'is-active' : ''
                          }`
                        }
                      >
                        <span className="nav-link__icon nav-link__icon--child" aria-hidden="true">
                          •
                        </span>
                        <span className="nav-link__label">{itemLabel}</span>
                        <span className="nav-link__hover">{itemLabel}</span>
                      </NavLink>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </nav>
    </aside>
  );
}
