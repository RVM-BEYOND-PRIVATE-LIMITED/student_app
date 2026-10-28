// TeamAppGateway: the ONLY way feature modules touch team-app data.
// Decided in M0: service-to-service vs shared tables. Until then, code against
// this interface; tests use InMemoryTeamAppGateway. Spec § integrations: 5s
// per-call timeout, retries on idempotent calls only, circuit breaker -> cached reads.

export interface TeamCourse {
  id: string;
  name: string;
  pricePaise: number; // converted at boundary: team app rupees * 100. No other module sees rupees.
}

export interface TeamBatch {
  id: string;
  courseId: string;
  centreId: string;
  startsAt: string;
  endsAt: string;
  capacity: number;
}

export interface IntakeInput {
  phoneE164: string;
  fullName: string;
  dob?: string;
}

export interface TeamAppGateway {
  listCourses(): Promise<TeamCourse[]>;
  listBatches(courseId: string): Promise<TeamBatch[]>;
  createIntake(input: IntakeInput): Promise<{ intakeId: string }>;
  updateIntake(intakeId: string, patch: Partial<IntakeInput>): Promise<void>;
  finalizeIntake(intakeId: string): Promise<{ admissionId: string }>;
  createEnrolment(admissionId: string, batchId: string): Promise<void>;
  findReceiptByBookingRef(bookingRef: string): Promise<{ receiptNo: string; amountPaise: number } | null>;
  getAttendance(studentId: string): Promise<unknown[]>;
  getInstalments(admissionId: string): Promise<unknown[]>;
}

export function rupeesToPaise(rupeesWhole: number): number {
  return Math.round(rupeesWhole * 100);
}

export class InMemoryTeamAppGateway implements TeamAppGateway {
  courses: TeamCourse[] = [];
  batches: TeamBatch[] = [];
  intakes = new Map<string, IntakeInput & { finalized?: boolean }>();
  receipts = new Map<string, { receiptNo: string; amountPaise: number }>();

  async listCourses() {
    return this.courses;
  }
  async listBatches(courseId: string) {
    return this.batches.filter((b) => b.courseId === courseId);
  }
  async createIntake(input: IntakeInput) {
    const intakeId = `intake-${this.intakes.size + 1}`;
    this.intakes.set(intakeId, input);
    return { intakeId };
  }
  async updateIntake(intakeId: string, patch: Partial<IntakeInput>) {
    const cur = this.intakes.get(intakeId);
    if (!cur) throw new Error('intake not found');
    this.intakes.set(intakeId, { ...cur, ...patch });
  }
  async finalizeIntake(intakeId: string) {
    const cur = this.intakes.get(intakeId);
    if (!cur) throw new Error('intake not found');
    this.intakes.set(intakeId, { ...cur, finalized: true });
    return { admissionId: `adm-${intakeId}` };
  }
  async createEnrolment() {}
  async findReceiptByBookingRef(bookingRef: string) {
    return this.receipts.get(bookingRef) ?? null;
  }
  async getAttendance() {
    return [];
  }
  async getInstalments() {
    return [];
  }
}
