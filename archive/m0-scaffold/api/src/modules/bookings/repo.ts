// bookings/repo.ts — owns ONLY lms.bookings, lms.booking_items, lms.seat_holds, lms.batch_capacity.
// Capacity check uses SELECT ... FOR UPDATE in batch-ID order (see service.ts).
export interface BookingRepo {
  countActiveForStudent(studentId: string): Promise<number>;
}
