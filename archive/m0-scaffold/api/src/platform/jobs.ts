import PgBoss from 'pg-boss';
import type { AppConfig } from './config.js';

// Jobs run on pg-boss in schema lms_jobs (no Redis).
// API uses transaction pooler (<=10); worker uses direct/session connection (<=5).
// Queues mirror spec § Events table: outbox-relay every 2s, expire-holds 1m, etc.

export const QUEUES = [
  'outbox-relay',
  'expire-holds',
  'razorpay-reconcile',
  'confirm-stuck-payments',
  'close-stale-playback',
  'team-app-sync',
  'instalment-reminders',
  'undertaking-pdf',
  'backup-lms',
  'purge-retention',
] as const;

let boss: PgBoss | null = null;

export async function getBoss(cfg: AppConfig): Promise<PgBoss> {
  if (boss) return boss;
  boss = new PgBoss({
    connectionString: cfg.DIRECT_URL ?? cfg.DATABASE_URL,
    schema: 'lms_jobs',
    max: 5,
  });
  boss.on('error', (e) => console.error('[jobs] error', (e as Error).message));
  await boss.start();
  return boss;
}

export async function stopBoss(): Promise<void> {
  if (boss) {
    await boss.stop();
    boss = null;
  }
}
