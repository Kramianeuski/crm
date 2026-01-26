export type NavItem = {
  key: string;
  labelKey: string;
  permission: string;
  path: string;
};

export type NavSection = {
  key: string;
  labelKey: string;
  items: NavItem[];
};

export type NavGroup = {
  key: string;
  labelKey: string;
  sections: NavSection[];
};

export const NAV_GROUPS: NavGroup[] = [
  {
    key: 'settings',
    labelKey: 'sidebar_settings',
    sections: [
      {
        key: 'system',
        labelKey: 'settings_nav_system',
        items: [
          {
            key: 'system-general',
            labelKey: 'settings_system_general',
            permission: 'settings.view',
            path: '/settings#system-general'
          },
          {
            key: 'system-security',
            labelKey: 'settings_system_security',
            permission: 'settings.view',
            path: '/settings#system-security'
          },
          {
            key: 'audit',
            labelKey: 'settings_nav_audit',
            permission: 'audit.view',
            path: '/settings#audit'
          }
        ]
      },
      {
        key: 'users',
        labelKey: 'settings_nav_users',
        items: [
          {
            key: 'users-list',
            labelKey: 'settings_users_title',
            permission: 'users.view',
            path: '/settings#users-list'
          },
          {
            key: 'roles',
            labelKey: 'settings_nav_roles',
            permission: 'roles.view',
            path: '/settings#roles'
          },
          {
            key: 'departments',
            labelKey: 'settings_departments_title',
            permission: 'departments.view',
            path: '/settings#departments'
          }
        ]
      },
      {
        key: 'languages',
        labelKey: 'settings_nav_languages',
        items: [
          {
            key: 'languages',
            labelKey: 'settings_nav_languages',
            permission: 'i18n.languages.view',
            path: '/settings#languages'
          }
        ]
      }
    ]
  }
];
