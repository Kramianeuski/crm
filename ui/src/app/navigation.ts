export type NavItem = {
  key: string;
  labelKey: string;
  permission: string;
};

export type NavGroup = {
  key: 'users' | 'settings';
  labelKey: string;
  items: NavItem[];
};

export const NAV_GROUPS: NavGroup[] = [
  {
    key: 'users',
    labelKey: 'settings_nav_users',
    items: [
      { key: 'users', labelKey: 'settings_nav_users', permission: 'users.view' },
      { key: 'departments', labelKey: 'settings_departments_title', permission: 'departments.view' }
    ]
  },
  {
    key: 'settings',
    labelKey: 'sidebar_settings',
    items: [
      { key: 'system', labelKey: 'settings_nav_system', permission: 'settings.view' },
      { key: 'roles', labelKey: 'settings_nav_roles', permission: 'roles.view' },
      { key: 'languages', labelKey: 'settings_nav_languages', permission: 'i18n.languages.view' },
      { key: 'audit', labelKey: 'settings_nav_audit', permission: 'audit.view' }
    ]
  }
];
