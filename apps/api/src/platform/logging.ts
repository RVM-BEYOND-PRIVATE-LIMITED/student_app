import pino, { type Logger } from 'pino';
import type { AppConfig } from './config.js';

// Port of Scheduler_Backend pino usage + spec redaction paths.
// Never log phone, Aadhaar, OTP, tokens, full names, addresses.
const REDACT = [
  '*.phone',
  '*.phone_e164',
  '*.aadhaar',
  '*.otp',
  '*.token',
  '*.accessToken',
  '*.refreshToken',
  '*.authorization',
  'req.headers.authorization',
  '*.name',
  '*.full_name',
  '*.address',
  '*.s3_key',
  '*.number_ciphertext',
];

let logger: Logger | null = null;

export function getLogger(cfg?: Pick<AppConfig, 'LOG_LEVEL' | 'NODE_ENV'>): Logger {
  if (logger) return logger;
  logger = pino({
    level: cfg?.LOG_LEVEL ?? process.env.LOG_LEVEL ?? 'info',
    redact: { paths: REDACT, censor: '[REDACTED]' },
    base: { service: 'student-api' },
  });
  return logger;
}
