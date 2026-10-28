import { writeFileSync } from 'node:fs';
import { buildApp } from '../server.js';

// Emits packages/openapi/openapi.yaml. CI fails if it drifts.
const app = buildApp();
await app.ready();
const yaml = app.swagger({ yaml: true }) as unknown as string;
writeFileSync(new URL('../../../../packages/openapi/openapi.yaml', import.meta.url), yaml);
console.log('openapi written');
await app.close();
