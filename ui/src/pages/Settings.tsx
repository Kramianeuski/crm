const sections = [
  {
    title: 'System',
    description: 'Базовые параметры системы. API ready for future settings.'
  },
  {
    title: 'Users',
    description: 'Управление пользователями будет добавлено в следующих релизах.'
  },
  {
    title: 'Roles',
    description: 'Гранулярные роли и права доступа появятся здесь.'
  },
  {
    title: 'Languages',
    description: 'Локализации интерфейса и контента.'
  }
];

export default function Settings() {
  return (
    <div className="page">
      <div className="page__header">
        <div>
          <p className="muted">Workspace</p>
          <h1 className="page__title">Settings</h1>
        </div>
        <span className="badge">MVP</span>
      </div>
      <div className="grid">
        {sections.map((section) => (
          <div key={section.title} className="card">
            <h2 className="card__title">{section.title}</h2>
            <p className="muted">{section.description}</p>
            <div className="card__footer">
              <button className="button button-ghost" type="button" disabled>
                Скоро
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
