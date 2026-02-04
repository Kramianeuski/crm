import { useEffect, useMemo, useState } from 'react';
import { useParams } from 'react-router-dom';
import { NavigationItem, fetchNavigation } from '../app/api';
import { useI18n } from '../app/i18n';

function resolveLabel(
  t: (key: string) => string,
  item: Pick<NavigationItem, 'title' | 'title_key'>
): string {
  if (item.title_key) {
    const translated = t(item.title_key);
    if (
      translated &&
      !translated.startsWith('[missing:') &&
      translated !== item.title_key
    ) {
      return translated;
    }
  }
  return item.title;
}

export default function ModulePlaceholder() {
  const { t } = useI18n();
  const params = useParams();
  const [navigation, setNavigation] = useState<NavigationItem[]>([]);

  useEffect(() => {
    let isMounted = true;
    fetchNavigation()
      .then((data) => {
        if (!isMounted) return;
        setNavigation(data);
      })
      .catch((err) => {
        // eslint-disable-next-line no-console
        console.error('Failed to load navigation', err);
      });

    return () => {
      isMounted = false;
    };
  }, []);

  const { moduleEntry, pageEntry } = useMemo(() => {
    const moduleCode = params.module ?? '';
    const pageCode = params.page ?? '';
    const moduleMatch = navigation.find((item) => item.code === moduleCode);
    const pageMatch = moduleMatch?.children?.find((child) => child.code === pageCode);
    return { moduleEntry: moduleMatch, pageEntry: pageMatch };
  }, [navigation, params.module, params.page]);

  const title = pageEntry
    ? resolveLabel(t, pageEntry)
    : moduleEntry
      ? resolveLabel(t, moduleEntry)
      : params.page || params.module || '';

  return (
    <div className="page">
      <div className="card">
        <h2 className="card__title">{title}</h2>
        <p className="muted">Раздел в разработке.</p>
      </div>
    </div>
  );
}
