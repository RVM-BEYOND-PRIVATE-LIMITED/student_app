import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { PostgreSqlContainer } from '@testcontainers/postgresql';

// Migration test against real Postgres (spec: endpoint ships with Testcontainers test).
// Runs 0000_init_lms.sql, asserts core tables exist and RLS is enabled with no policies.
describe('0000_init_lms migration', () => {
  it('creates lms tables with RLS and no policies', async () => {
    const container = await new PostgreSqlContainer('postgres:15').start();
    try {
      const { Client } = await import('pg');
      const client = new Client({ connectionString: container.getConnectionUri() });
      await client.connect();
      try {
        await client.query('CREATE EXTENSION IF NOT EXISTS "pgcrypto"');
        const sql = readFileSync(new URL('../migrations/0000_init_lms.sql', import.meta.url), 'utf8');
        await client.query(sql);
        const tables = await client.query(
          `select tablename from pg_tables where schemaname='lms' order by 1`,
        );
        const names = tables.rows.map((r) => r.tablename);
        for (const t of ['bookings', 'payments', 'outbox', 'idempotency_keys', 'student_accounts', 'view_counters']) {
          expect(names).toContain(t);
        }
        const rls = await client.query(
          `select tablename, rowsecurity from pg_tables where schemaname='lms'`,
        );
        for (const row of rls.rows) {
          expect(row.rowsecurity).toBe(true);
        }
        const policies = await client.query(`select count(*)::int as n from pg_policies where schemaname='lms'`);
        expect(policies.rows[0].n).toBe(0);
      } finally {
        await client.end();
      }
    } finally {
      await container.stop();
    }
  }, 120000);
});
