export interface PlaybackGate {
  entitled: boolean;
  withinExpiry: boolean;
  viewsUsed: number;
  maxViews: number;
  extraViewsGranted: number;
  deviceActive: boolean;
  integrityFresh: boolean;
  otherOpenSession: boolean;
}

export function canStartPlayback(g: PlaybackGate): { ok: true } | { ok: false; reason: string } {
  if (!g.entitled || !g.withinExpiry) return { ok: false, reason: 'NOT_ENTITLED' };
  if (g.viewsUsed >= g.maxViews + g.extraViewsGranted) return { ok: false, reason: 'VIEWS_EXHAUSTED' };
  if (!g.deviceActive || !g.integrityFresh) return { ok: false, reason: 'DEVICE_NOT_TRUSTED' };
  if (g.otherOpenSession) return { ok: false, reason: 'SESSION_ALREADY_OPEN' };
  return { ok: true };
}

// A view is counted the first time max_position_s passes count_after_pct of duration.
// Opening the player never costs a view. Crash-resume within resume_window_min reuses session.
export function shouldCountView(args: {
  alreadyCounted: boolean;
  maxPositionS: number;
  durationS: number;
  countAfterPct: number;
}): boolean {
  if (args.alreadyCounted) return false;
  if (args.durationS <= 0) return false;
  return args.maxPositionS * 100 >= args.countAfterPct * args.durationS;
}

export function isResumeAllowed(args: { nowMs: number; lastHeartbeatMs: number; resumeWindowMin: number }): boolean {
  return args.nowMs - args.lastHeartbeatMs <= args.resumeWindowMin * 60_000;
}
