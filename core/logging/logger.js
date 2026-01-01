'use strict';

const pino = require('pino');

function createLogger() {
  const isProd = process.env.CORE_ENV === 'production';

  return pino({
    level: isProd ? 'info' : 'debug',
    transport: !isProd
      ? {
          target: 'pino-pretty',
          options: { colorize: true }
        }
      : undefined
  });
}

module.exports = { createLogger };
