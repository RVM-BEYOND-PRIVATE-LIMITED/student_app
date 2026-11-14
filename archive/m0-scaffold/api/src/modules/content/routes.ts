import type { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { canStartPlayback, shouldCountView } from './service.js';
import { store } from '../_store.js';

function sidOf(req: { headers: Record<string, unknown> }): string {
  const h = (req.headers['authorization'] as string) || '';
  const m = h.match(/^Bearer test\.(.+)$/);
  if (!m?.[1]) throw Object.assign(new Error('UNAUTHORIZED'), { statusCode: 401 });
  return m[1] as string;
}

export async function registerContentRoutes(app: FastifyInstance) {
  const r = app.withTypeProvider<ZodTypeProvider>();
  r.get('/v1/me/library', async () => ({ videos: [], entitlements: [] }));
  r.post(
    '/v1/playback/sessions',
    { schema: { body: z.object({ video_id: z.string().uuid(), device_id: z.string().uuid() }) } },
    async (req) => {
      const sid = sidOf(req as unknown as { headers: Record<string, unknown> });
      const gate = canStartPlayback({
        entitled: true, withinExpiry: true, viewsUsed: 0, maxViews: 1, extraViewsGranted: 0,
        deviceActive: true, integrityFresh: true,
        otherOpenSession: [...store.playbackSessions.values()].some((s) => s.studentId === sid && s.open),
      });
      if (!gate.ok) throw Object.assign(new Error(gate.reason), { statusCode: 409 });
      const id = crypto.randomUUID();
      store.playbackSessions.set(id, { id, studentId: sid, videoId: req.body.video_id, open: true, counted: false, maxPositionS: 0 });
      return { id };
    },
  );
  r.post(
    '/v1/playback/sessions/:id/heartbeat',
    { schema: { params: z.object({ id: z.string().uuid() }), body: z.object({ position_s: z.number().int().min(0) }) } },
    async (req) => {
      const s = store.playbackSessions.get(req.params.id);
      if (!s || !s.open) throw Object.assign(new Error('NOT_FOUND'), { statusCode: 404 });
      s.maxPositionS = Math.max(s.maxPositionS, req.body.position_s);
      if (shouldCountView({ alreadyCounted: s.counted, maxPositionS: s.maxPositionS, durationS: 3600, countAfterPct: 5 })) {
        s.counted = true;
      }
      return { ok: true, counted: s.counted, stop: false as boolean };
    },
  );
  r.post('/v1/playback/sessions/:id/end', { schema: { params: z.object({ id: z.string().uuid() }) } }, async (req) => {
    const s = store.playbackSessions.get(req.params.id);
    if (s) s.open = false;
    return { ok: true };
  });
}
