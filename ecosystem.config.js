module.exports = {
  apps: [
    {
      name: 'crm-core',
      cwd: '/var/www/crm/core',
      script: 'node',
      args: 'server.js',
      env_file: '/etc/crm/core.env',
    },
  ],
};
