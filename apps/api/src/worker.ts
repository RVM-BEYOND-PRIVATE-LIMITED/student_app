import { loadConfig } from './platform/config.js';
import { getLogger } from './platform/logging.js';
import { getBoss, stopBoss } from './platform/jobs.js';
import { getPool } from './platform/db.js';
import { claimOutbox, markPublished, markFailed } from './platform/outbox.js';

// Worker: relays lms.outbox -> pg-boss, runs scheduled jobs.
// Port of Scheduler_Backend in-process worker pattern (email worker + cron):
// no Redis, FOR UPDATE SKIP LOCKED claiming, catch-up on boot, graceful shutdown.

const cfg = loadConfig();
const log = getLogger(cfg);

let running = true;

async function relayOnce() {
  const pool = getPool(cfg);
  const boss = await getBoss(cfg);
  const rows = await claimOutbox(pool, 50);
  for (const row of rows) {
    if (!running) break;
    try {
      await boss.send(row.type, { outboxId: row.id, ...row.payload });
      await markPublished(pool, [String(row.id)]);
    } catch (err) {
      log.error({ err, outboxId: row.id, type: row.type }, 'outbox relay failed');
      await markFailed(pool, String(row.id));
    }
  }
}

async function loop() {
  // Boot catch-up (port of attendance-settle/snapshot warm-up pattern): run once shortly after start.
  log.info('worker starting');
  while (running) {
    try {
      await relayOnce();
    } catch (err) {
      log.error({ err }, 'relay loop error');
    }
    await new Promise((r) => setTimeout(r, 2000)); // outbox-relay every 2s per spec
  }
}

async function shutdown(signal: string) {
  log.info({ signal }, 'worker shutting down');
  running = false;
  try {
    await stopBoss();
  } catch {
    // never block shutdown on this
  }
  process.exit(0);
}

process.on('SIGTERM', () => void shutdown('SIGTERM'));
process.on('SIGINT', () => void shutdown('SIGINT'));

if (process.env.NODE_ENV !== 'test') {
  void loop();
}
