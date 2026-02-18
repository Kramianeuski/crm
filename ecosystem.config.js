module.exports = {
  apps: [
    {
      name: 'crm-core',
      cwd: '/var/www/crm',
      script: 'node',
      args: 'apps/crm-api/server.js',
      env_file: '/etc/crm/core.env',
    },
  ],
};
