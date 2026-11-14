import type { FastifyRequest } from 'fastify';
import { createRemoteJWKSet, jwtVerify } from 'jose';

// Port of Scheduler_Backend middleware/auth.js semantics into student JWT (EdDSA, jose):
// - 401 only for absent/rejected token; DB outage is 503 (never mass sign-out).
// - token must name somebody (sub + device_id); look-alikes refused as 401.
// - every student query filters by student_id from token (404 matrix in tests).
// - password/session version: `sv` claim vs DB; reuse of old refresh family revokes it (see identity module).

export interface StudentToken {
  sub: string; // student_account id
  device_id: string;
  sv: number; // session version
}

export async function verifyAccessToken(
  req: FastifyRequest,
  jwksUrlOrSet: ReturnType<typeof createRemoteJWKSet> | URL,
  audience?: string,
): Promise<{ ok: true; token: StudentToken } | { ok: false; status: 401 | 503; code: string; message: string }> {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return { ok: false, status: 401, code: 'NO_TOKEN', message: 'No token provided' };
  }
  const token = header.slice('Bearer '.length);
  try {
    const jwks = jwksUrlOrSet instanceof URL ? createRemoteJWKSet(jwksUrlOrSet) : jwksUrlOrSet;
    const { payload } = await jwtVerify(token, jwks, audience ? { audience } : undefined);
    const sub = payload.sub;
    const deviceId = (payload as Record<string, unknown>).device_id;
    if (typeof sub !== 'string' || typeof deviceId !== 'string') {
      return { ok: false, status: 401, code: 'INVALID_TOKEN', message: 'Please authenticate' };
    }
    return { ok: true, token: { sub, device_id: deviceId, sv: Number((payload as Record<string, unknown>).sv ?? 0) } };
  } catch (err) {
    const expired = (err as Error)?.name === 'JWTExpired';
    return {
      ok: false,
      status: 401,
      code: expired ? 'TOKEN_EXPIRED' : 'INVALID_TOKEN',
      message: expired ? 'Your session has expired. Please sign in again.' : 'Please authenticate',
    };
  }
}

export function requireServiceToken(req: FastifyRequest, expected: string, allowlist: string[]): boolean {
  const token = req.headers['x-service-token'];
  if (token !== expected) return false;
  const ip = (req.headers['x-forwarded-for'] as string)?.split(',')[0]?.trim() || req.ip;
  if (allowlist.length > 0 && !allowlist.includes(ip) && !allowlist.includes('*')) return false;
  return true;
}
