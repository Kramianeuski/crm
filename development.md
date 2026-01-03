# Development notes

## CRM Core environment configuration

Runtime configuration for the backend core is loaded from `/etc/crm/core.env`. The repository does not store secrets, so create that file locally with the required variables before starting the server.

Example layout for `/etc/crm/core.env`:

```
CORE_PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=crm
DB_USER=crm_user
DB_PASSWORD=change_me
JWT_SECRET=super_secret_token
```

Adjust the values to match your environment; avoid committing real credentials to the repository.
