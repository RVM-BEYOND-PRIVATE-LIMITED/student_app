import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'staging', 'production']).default('development'),
  PORT: z.coerce.number().default(3000),
  LOG_LEVEL: z.string().default('info'),
  DATABASE_URL: z.string().min(1),
  DIRECT_URL: z.string().min(1).optional(),
  PG_POOL_MAX_API: z.coerce.number().default(10),
  PG_STATEMENT_TIMEOUT_MS: z.coerce.number().default(15000),
  JWT_PRIVATE_JWK_JSON: z.string().default('{}'),
  JWT_PUBLIC_JWK_JSON: z.string().default('{}'),
  JWT_ACCESS_TTL_MIN: z.coerce.number().default(15),
  JWT_REFRESH_TTL_DAYS: z.coerce.number().default(30),
  INTERNAL_SERVICE_TOKEN: z.string().min(1),
  INTERNAL_IP_ALLOWLIST: z.string().default('127.0.0.1'),
  SENTRY_DSN: z.string().default(''),
  AUDIT_MODE: z.enum(['on', 'off']).default('on'),
  S3_BUCKET: z.string().default(''),
  S3_REGION: z.string().default('ap-south-1'),
});

export type AppConfig = z.infer<typeof envSchema>;

export function loadConfig(env: NodeJS.ProcessEnv = process.env): AppConfig {
  const parsed = envSchema.safeParse(env);
  if (!parsed.success) {
    console.error('Invalid environment:', parsed.error.flatten().fieldErrors);
    throw new Error('Invalid environment configuration (fail fast)');
  }
  // Hard rule: never allow prod DB from dev/agent sessions.
  if (parsed.data.NODE_ENV !== 'production') {
    // Cheap guard: block obvious prod hostnames. Real guard is separate creds + review.
    const url = parsed.data.DATABASE_URL.toLowerCase();
    if (url.includes('prod') && !url.includes('staging')) {
      throw new Error('Refusing to use a production-looking DATABASE_URL outside production');
    }
  }
  return parsed.data;
}
