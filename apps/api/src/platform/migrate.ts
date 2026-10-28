import { readFileSync } from 'node:fs';
import { Pool } from 'pg';
import { loadConfig } from './config.js';

// Staging-only migrate runner. Prod runs via GitHub Actions manual approval after backup.
const cfg = loadConfig();
if (!cfg.DIRECT_URL && cfg.NODE_ENV === 'production') {
  throw new Error('Refusing to migrate production from a local session');
}
const pool = new Pool({ connectionString: cfg.DIRECT_URL ?? cfg.DATABASE_URL });
const sql = readFileSync(new URL('../../migrations/0000_init_lms.sql', import.meta.url), 'utf8');
await pool.query(sql);
console.log('migrated: 0000_init_lms');
await pool.end();
