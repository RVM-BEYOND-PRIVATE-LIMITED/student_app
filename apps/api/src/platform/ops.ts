import type { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { checkDb } from './db.js';
import type { AppConfig } from './config.js';

export async function registerOpsRoutes(app: FastifyInstance, cfg: AppConfig, getBossHealth: () => Promise<boolean>) {
  app.get('/health', async () => ({ ok: true, service: 'student-api' }));

  app.get('/ready', async (_req, reply) => {
    const [dbOk, bossOk] = await Promise.all([
      checkDb(cfg).catch(() => false),
      getBossHealth().catch(() => false),
    ]);
    if (!dbOk || !bossOk) {
      reply.status(503).send({ ok: false, db: dbOk, queue: bossOk });
      return;
    }
    return { ok: true, db: dbOk, queue: bossOk };
  });

  const configSchema = z.object({
    min_supported_version: z.string(),
    latest_version: z.string(),
    analytics_allowed_default: z.boolean(),
  });

  app.get('/v1/config', async () => {
    // Per-device analytics_allowed resolved per student (minors => false). Default here.
    return configSchema.parse({
      min_supported_version: '1.0.0',
      latest_version: '1.0.0',
      analytics_allowed_default: true,
    });
  });
}
