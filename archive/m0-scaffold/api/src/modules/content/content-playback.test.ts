import { describe, it, expect } from 'vitest';
import { canStartPlayback, shouldCountView, isResumeAllowed } from './service.js';

describe('playback single-view rules', () => {
  const base = { entitled: true, withinExpiry: true, viewsUsed: 0, maxViews: 1, extraViewsGranted: 0, deviceActive: true, integrityFresh: true, otherOpenSession: false };
  it('allows first view on trusted device', () => {
    expect(canStartPlayback(base)).toEqual({ ok: true });
  });
  it('blocks when views exhausted, untrusted device, or second session', () => {
    expect(canStartPlayback({ ...base, viewsUsed: 1 }).ok).toBe(false);
    expect(canStartPlayback({ ...base, deviceActive: false }).ok).toBe(false);
    expect(canStartPlayback({ ...base, integrityFresh: false }).ok).toBe(false);
    expect(canStartPlayback({ ...base, otherOpenSession: true }).ok).toBe(false);
    expect(canStartPlayback({ ...base, entitled: false }).ok).toBe(false);
    expect(canStartPlayback({ ...base, viewsUsed: 1, extraViewsGranted: 1 }).ok).toBe(true);
  });
  it('counts view only after threshold, once', () => {
    expect(shouldCountView({ alreadyCounted: false, maxPositionS: 4, durationS: 100, countAfterPct: 5 })).toBe(false);
    expect(shouldCountView({ alreadyCounted: false, maxPositionS: 6, durationS: 100, countAfterPct: 5 })).toBe(true);
    expect(shouldCountView({ alreadyCounted: true, maxPositionS: 90, durationS: 100, countAfterPct: 5 })).toBe(false);
  });
  it('crash resume within window allowed', () => {
    const now = Date.now();
    expect(isResumeAllowed({ nowMs: now, lastHeartbeatMs: now - 30 * 60_000, resumeWindowMin: 60 })).toBe(true);
    expect(isResumeAllowed({ nowMs: now, lastHeartbeatMs: now - 61 * 60_000, resumeWindowMin: 60 })).toBe(false);
  });
});
