import { useEffect, useMemo, useState } from 'react';
import { Warehouse, fetchWarehouses } from '../app/api';
import { useI18n } from '../app/i18n';

export default function Warehouses() {
  const { t } = useI18n();
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    setLoading(true);
    fetchWarehouses()
      .then((data) => {
        if (!isMounted) return;
        setWarehouses(data);
        setError(null);
      })
      .catch((err) => {
        if (!isMounted) return;
        setError(err.message || 'Failed to load warehouses');
      })
      .finally(() => {
        if (!isMounted) return;
        setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, []);

  const title = t('settings.warehouse.list');
  const subtitle = useMemo(() => {
    if (loading) return t('app_loading');
    if (error) return error;
    if (warehouses.length === 0) return 'Нет данных';
    return `Всего складов: ${warehouses.length}`;
  }, [error, loading, t, warehouses.length]);

  return (
    <div className="page">
      <div className="card stack">
        <div>
          <h2 className="card__title">{title}</h2>
          <p className="muted">{subtitle}</p>
        </div>
        {!loading && !error && warehouses.length > 0 && (
          <div className="table-wrapper">
            <table className="table">
              <thead>
                <tr>
                  <th>Код</th>
                  <th>Название</th>
                  <th>Город</th>
                  <th>Статус</th>
                </tr>
              </thead>
              <tbody>
                {warehouses.map((warehouse) => (
                  <tr key={warehouse.id}>
                    <td>{warehouse.code}</td>
                    <td>{warehouse.name}</td>
                    <td>{warehouse.city}</td>
                    <td>
                      <span
                        className={`status ${warehouse.is_active ? 'status-active' : 'status-inactive'}`}
                      >
                        {warehouse.is_active ? 'Активен' : 'Неактивен'}
                      </span>
                    </td>
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
