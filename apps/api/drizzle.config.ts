import type { Config } from 'drizzle-kit';

export default {
  schema: './src/platform/schema.ts',
  out: './migrations',
  dialect: 'postgresql',
  schemaFilter: ['lms'],
} satisfies Config;
