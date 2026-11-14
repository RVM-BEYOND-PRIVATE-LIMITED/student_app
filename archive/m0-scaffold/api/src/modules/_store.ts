import { randomUUID } from 'node:crypto';

// M0 in-memory store. Replaced by Drizzle + lms tables in M1+.
// Keeps module boundaries: each module imports only its slice via accessor fns.
export interface BookingRecord {
  id: string;
  booking_ref: string;
  student_id: string;
  status: string;
  fee_plan: string;
  subtotal_paise: number;
  discount_paise: number;
  total_paise: number;
  seat_fee_paise: number;
  price_snapshot: Record<string, unknown>;
  hold_expires_at: string | null;
}

export const store = {
  bookingsById: new Map<string, BookingRecord>(),
  bookingsByRef: new Map<string, BookingRecord>(),
  otpChallenges: new Map<string, { codeHash: string; expiresAt: number; attempts: number }>(),
  playbackSessions: new Map<string, { id: string; studentId: string; videoId: string; open: boolean; counted: boolean; maxPositionS: number }>(),
};

export function newBookingRef(): string {
  return 'BK-' + randomUUID().slice(0, 8).toUpperCase();
}
