import Fastify from 'fastify';
import rateLimit from '@fastify/rate-limit';
import swagger from '@fastify/swagger';
import * as Sentry from '@sentry/node';
import { jsonSchemaTransform, serializerCompiler, validatorCompiler } from 'fastify-type-provider-zod';
import { loadConfig } from './platform/config.js';
import { getLogger } from './platform/logging.js';
import { auditContext } from './platform/http.js';
import { stripSecrets, notFoundHandler } from './platform/stripSecrets.js';
import { registerOpsRoutes } from './platform/ops.js';
import { registerPricingRoutes } from './modules/pricing/routes.js';
import { registerBookingRoutes } from './modules/bookings/routes.js';
import { registerIdentityRoutes } from './modules/identity/routes.js';
import { registerCatalogRoutes } from './modules/catalog/routes.js';
import { registerContentRoutes } from './modules/content/routes.js';
import { registerPaymentRoutes } from './modules/payments/routes.js';
import { registerGuardianRoutes } from './modules/guardians/routes.js';
import { registerKycRoutes } from './modules/kyc/routes.js';
import { registerStudentCoreRoutes } from './modules/students/routes.js';
import { registerTicketRoutes } from './modules/tickets/routes.js';
import { registerNotificationRoutes } from './modules/notifications/routes.js';
import { registerLiveRoutes } from './modules/live/routes.js';
import { registerBatchRoutes } from './modules/batches/routes.js';
import { registerFeeRoutes } from './modules/fees/routes.js';

const cfg = loadConfig();
const log = getLogger(cfg);

if (cfg.SENTRY_DSN) {
  Sentry.init({ dsn: cfg.SENTRY_DSN, environment: cfg.NODE_ENV });
}

export async function buildApp() {
  const app = Fastify({
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    loggerInstance: log as any,
    // Port of Scheduler_Backend: trust single proxy so rate limiters key on real ip.
    // Fastify v5 types accept boolean here; `true` trusts X-Forwarded-For from the front proxy.
    trustProxy: true,
  });

  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);

  // Spec error shape { code, message, details, request_id } — never leak secrets (stripSecrets).
  app.setErrorHandler((err: Error & { statusCode?: number }, req, reply) => {
    const status = (err as { statusCode?: number }).statusCode ?? 500;
    const code = status === 404 ? 'NOT_FOUND' : status === 409 ? 'CONFLICT' : status === 401 ? 'UNAUTHORIZED' : status === 429 ? 'RATE_LIMITED' : 'INTERNAL';
    if (status >= 500) {
      app.log.error({ err, request_id: req.requestId }, 'unhandled');
      if (cfg.SENTRY_DSN) Sentry.captureException(err);
    }
    reply.status(status).send({ code, message: err.message || 'error', request_id: req.requestId });
  });

  await auditContext(app);
  await stripSecrets(app);

  await app.register(rateLimit, {
    global: true,
    max: 300,
    timeWindow: '1 minute',
    keyGenerator: (req) =>
      (req.headers['x-forwarded-for'] as string | undefined)?.split(',')[0]?.trim() || req.ip,
  });

  await app.register(swagger, {
    openapi: {
      info: { title: 'RVM Student App API', version: '1.0.0' },
      servers: [{ url: '/v1' }],
    },
    transform: jsonSchemaTransform,
  });

  await registerOpsRoutes(app, cfg, async () => true);
  await registerIdentityRoutes(app);
  await registerGuardianRoutes(app);
  await registerKycRoutes(app);
  await registerStudentCoreRoutes(app);
  await registerCatalogRoutes(app);
  await registerBatchRoutes(app);
  await registerPricingRoutes(app);
  await registerBookingRoutes(app);
  await registerPaymentRoutes(app);
  await registerContentRoutes(app);
  await registerLiveRoutes(app);
  await registerTicketRoutes(app);
  await registerNotificationRoutes(app);
  await registerFeeRoutes(app);

  notFoundHandler(app);
  return app;
}

if (process.env.NODE_ENV !== 'test') {
  const app = await buildApp();
  app
    .listen({ port: cfg.PORT, host: '0.0.0.0' })
    .then(() => log.info({ port: cfg.PORT }, 'student-api listening'))
    .catch((err) => {
      log.error({ err }, 'failed to start');
      process.exit(1);
    });
}
