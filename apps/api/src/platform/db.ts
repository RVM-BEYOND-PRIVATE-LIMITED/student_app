import { Pool } from 'pg';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AppConfig } from './config.js';

let pool: Pool | null = null;
let db: NodePgDatabase | null = null;

export function getPool(cfg: AppConfig): Pool {
  if (pool) return pool;
  pool = new Pool({
    connectionString: cfg.DATABASE_URL,
    max: cfg.PG_POOL_MAX_API, // spec: API <= 10 via transaction pooler (port 6543)
    // Transaction pooler requires prepared statements disabled.
    // pg has them off by default unless using named prepared queries; drizzle
    // must not use `prepare: true` paths. Keep it simple: raw pool, no pgBouncer stmt cache.
    statement_timeout: cfg.PG_STATEMENT_TIMEOUT_MS, // 15s per spec (role default)
    query_timeout: cfg.PG_STATEMENT_TIMEOUT_MS,
    idle_in_transaction_session_timeout: 30000,
  });
  pool.on('error', (err) => {
    // Never log connection string; pg error is safe.
    console.error('[db] pool error', (err as Error).message);
  });
  return pool;
}

export function getDb(cfg: AppConfig): NodePgDatabase {
  if (db) return db;
  db = drizzle(getPool(cfg));
  return db;
}

export async function checkDb(cfg: AppConfig): Promise<boolean> {
  const p = getPool(cfg);
  const client = await p.connect();
  try {
    await client.query('select 1');
    return true;
  } finally {
    client.release();
  }
}
