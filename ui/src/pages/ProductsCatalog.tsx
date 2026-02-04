import { useEffect, useMemo, useState } from 'react';
import { Category, fetchCategories } from '../app/api';
import { useI18n } from '../app/i18n';

function CategoryNode({ category }: { category: Category }) {
  const label = category.name || category.code || category.slug;
  return (
    <div className="tree__node">
      <div>
        <div className="card__title">{label}</div>
        {category.description && <div className="muted">{category.description}</div>}
      </div>
      {category.is_active === false && <span className="status status-inactive">Inactive</span>}
    </div>
  );
}

export default function ProductsCatalog() {
  const { t, language } = useI18n();
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    setLoading(true);
    fetchCategories(language)
      .then((data) => {
        if (!isMounted) return;
        setCategories(data);
        setError(null);
      })
      .catch((err) => {
        if (!isMounted) return;
        setError(err.message || 'Failed to load catalog');
      })
      .finally(() => {
        if (!isMounted) return;
        setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [language]);

  const title = t('settings.products.catalog');
  const hasCategories = categories.length > 0;
  const subtitle = useMemo(() => {
    if (loading) return t('app_loading');
    if (error) return error;
    if (!hasCategories) return 'Нет данных';
    return 'Список категорий и их дерево.';
  }, [error, hasCategories, loading, t]);

  const renderTree = (nodes: Category[]) => (
    <div className="tree">
      {nodes.map((category) => (
        <div key={category.id} className="tree__branch">
          <CategoryNode category={category} />
          {category.children && category.children.length > 0 && (
            <div className="tree__children">{renderTree(category.children)}</div>
          )}
        </div>
      ))}
    </div>
  );

  return (
    <div className="page">
      <div className="card stack">
        <div>
          <h2 className="card__title">{title}</h2>
          <p className="muted">{subtitle}</p>
        </div>
        {!loading && !error && hasCategories && renderTree(categories)}
      </div>
    </div>
  );
}
