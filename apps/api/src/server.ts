import Fastify from 'fastify';
import rateLimit from '@fastify/rate-limit';
import swagger from '@fastify/swagger';
import * as Sentry from '@sentry/node';
import { loadConfig } from './platform/config.js';
import { getLogger } from './platform/logging.js';
import { auditContext } from './platform/http.js';
import { stripSecrets, notFoundHandler } from './platform/stripSecrets.js';
import { registerOpsRoutes } from './platform/ops.js';

const cfg = loadConfig();
const log = getLogger(cfg);

if (cfg.SENTRY_DSN) {
  Sentry.init({ dsn: cfg.SENTRY_DSN, environment: cfg.NODE_ENV });
}

export function buildApp() {
  const app = Fastify({
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    loggerInstance: log as any,
    // Port of Scheduler_Backend: trust single proxy so rate limiters key on real ip.
    // Fastify v5 types accept boolean here; `true` trusts X-Forwarded-For from the front proxy.
    trustProxy: true,
    requestIdLogLabel: 'request_id',
  });

  void auditContext(app);
  void stripSecrets(app);

  void app.register(rateLimit, {
    global: true,
    max: 300,
    timeWindow: '1 minute',
    keyGenerator: (req) =>
      (req.headers['x-forwarded-for'] as string | undefined)?.split(',')[0]?.trim() || req.ip,
  });

  // OTP-grade limiter applied per-route in identity/guardian modules (spec: 3/phone/15min, 10/IP/hr).
  void app.register(swagger, {
    openapi: {
      info: { title: 'RVM Student App API', version: '1.0.0' },
      servers: [{ url: '/v1' }],
    },
  });

  void registerOpsRoutes(app, cfg, async () => true);

  // TODO(M1+): register modules/identity, guardians, kyc, catalog, pricing, batches,
  // bookings, payments, fees, content, live, tickets, notifications, audit.
  // Each module: routes.ts (Zod), service.ts (public iface), repo.ts (own tables only),
  // schemas.ts, events.ts, *.test.ts.

  notFoundHandler(app);
  return app;
}

if (process.env.NODE_ENV !== 'test') {
  const app = buildApp();
  app
    .listen({ port: cfg.PORT, host: '0.0.0.0' })
    .then(() => log.info({ port: cfg.PORT }, 'student-api listening'))
    .catch((err) => {
      log.error({ err }, 'failed to start');
      process.exit(1);
    });
}
