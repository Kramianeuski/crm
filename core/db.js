import { Pool } from 'pg';

function validateDbEnv() {
  const required = [
    'DB_HOST',
    'DB_PORT',
    'DB_NAME',
    'DB_USER',
    'DB_PASSWORD'
  ];

  for (const key of required) {
    if (!process.env[key]) {
      throw new Error(`Missing required DB env var: ${key}`);
    }
  }

  const dbPort = Number(process.env.DB_PORT);
  if (Number.isNaN(dbPort)) {
    throw new Error('DB_PORT must be a number');
  }
}

validateDbEnv();

const dbPort = Number(process.env.DB_PORT);

export const pool = new Pool({
  host: process.env.DB_HOST,
  port: dbPort,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: Number(process.env.DB_POOL_SIZE || 20),
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 2_000,
  ssl: process.env.DB_SSL === 'true'
    ? { rejectUnauthorized: false }
    : undefined
});

pool.on('error', err => {
  console.error(err, 'PostgreSQL pool error');
});
