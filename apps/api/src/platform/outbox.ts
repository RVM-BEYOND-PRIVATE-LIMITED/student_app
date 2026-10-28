import type { Pool, PoolClient } from 'pg';

// Every state change that matters writes an outbox event in the SAME transaction.
// Worker relays lms.outbox -> pg-boss. Idempotent handlers keyed by outbox id.

export interface OutboxEvent {
  aggregate: string;
  aggregate_id: string;
  type: string;
  payload: Record<string, unknown>;
}

export async function writeOutbox(client: Pool | PoolClient, events: OutboxEvent[]): Promise<void> {
  if (events.length === 0) return;
  const values: unknown[] = [];
  const rows = events
    .map((e, i) => {
      const o = i * 4;
      values.push(e.aggregate, e.aggregate_id, e.type, JSON.stringify(e.payload));
      return `($${o + 1}, $${o + 2}, $${o + 3}, $${o + 4})`;
    })
    .join(',');
  await (client as PoolClient).query(
    `insert into lms.outbox (aggregate, aggregate_id, type, payload) values ${rows}`,
    values,
  );
}

export interface OutboxRow {
  id: string;
  aggregate: string;
  aggregate_id: string;
  type: string;
  payload: Record<string, unknown>;
  attempts: number;
}

export async function claimOutbox(pool: Pool, limit = 50): Promise<OutboxRow[]> {
  const { rows } = await pool.query(
    `select id, aggregate, aggregate_id, type, payload, attempts
     from lms.outbox
     where published_at is null
     order by id asc
     limit $1
     for update skip locked`,
    [limit],
  );
  return rows as OutboxRow[];
}

export async function markPublished(pool: Pool, ids: string[]): Promise<void> {
  if (ids.length === 0) return;
  await pool.query(`update lms.outbox set published_at = now() where id = any($1::bigint[])`, [ids]);
}

export async function markFailed(pool: Pool, id: string): Promise<void> {
  await pool.query(`update lms.outbox set attempts = attempts + 1 where id = $1`, [id]);
}
