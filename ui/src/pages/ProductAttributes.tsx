import { useEffect, useMemo, useState } from 'react';
import { Attribute, fetchAttributes } from '../app/api';
import { useI18n } from '../app/i18n';

export default function ProductAttributes() {
  const { t, language } = useI18n();
  const [attributes, setAttributes] = useState<Attribute[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    setLoading(true);
    fetchAttributes(language)
      .then((data) => {
        if (!isMounted) return;
        setAttributes(data);
        setError(null);
      })
      .catch((err) => {
        if (!isMounted) return;
        setError(err.message || 'Failed to load attributes');
      })
      .finally(() => {
        if (!isMounted) return;
        setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [language]);

  const title = t('settings.products.attributes');
  const subtitle = useMemo(() => {
    if (loading) return t('app_loading');
    if (error) return error;
    if (attributes.length === 0) return 'Нет данных';
    return `Всего атрибутов: ${attributes.length}`;
  }, [attributes.length, error, loading, t]);

  return (
    <div className="page">
      <div className="card stack">
        <div>
          <h2 className="card__title">{title}</h2>
          <p className="muted">{subtitle}</p>
        </div>
        {!loading && !error && attributes.length > 0 && (
          <div className="table-wrapper">
            <table className="table">
              <thead>
                <tr>
                  <th>Код</th>
                  <th>Название</th>
                  <th>Тип</th>
                  <th>Обязательный</th>
                </tr>
              </thead>
              <tbody>
                {attributes.map((attribute) => (
                  <tr key={attribute.id}>
                    <td>{attribute.code}</td>
                    <td>{attribute.name || '—'}</td>
                    <td>{attribute.value_type}</td>
                    <td>{attribute.is_required ? 'Да' : 'Нет'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
