export type ErrorCode =
  | 'BAD_REQUEST'
  | 'UNAUTHORIZED'
  | 'NO_TOKEN'
  | 'INVALID_TOKEN'
  | 'TOKEN_EXPIRED'
  | 'USER_NOT_FOUND'
  | 'PASSWORD_CHANGED'
  | 'FORBIDDEN'
  | 'NOT_FOUND'
  | 'CONFLICT'
  | 'RATE_LIMITED'
  | 'DATABASE_UNAVAILABLE'
  | 'AUTH_UNAVAILABLE'
  | 'INTERNAL';

export interface ApiErrorShape {
  code: ErrorCode;
  message: string;
  details?: unknown;
  request_id: string;
}

export function toApiError(code: ErrorCode, message: string, requestId: string, details?: unknown): ApiErrorShape {
  return { code, message, details, request_id: requestId };
}
