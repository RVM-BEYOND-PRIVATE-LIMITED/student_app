import { describe, it, expect } from 'vitest';
import { rupeesToPaise } from '../src/modules/integrations/gateway.js';

describe('rupeesToPaise (boundary conversion)', () => {
  it('converts whole rupees to integer paise', () => {
    expect(rupeesToPaise(15500)).toBe(1550000);
    expect(rupeesToPaise(18000)).toBe(1800000);
  });
});
