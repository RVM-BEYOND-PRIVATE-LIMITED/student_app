// The web version calls only what the published contract has (student_app #20 item 12, web-ci).
// Every '/v1/...' path in apps/web/*.js, a template part `${...}` read as one path parameter, must
// match a path of packages/openapi/openapi.yaml (where `{name}` matches one segment). No
// dependencies: the contract is read as text, as packages/openapi/tools/check-contract.mjs does.
import { readFileSync, readdirSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const ROOT = join(here, '..', '..', '..');

export function contractPaths(text) {
  const lines = text.split(/\r?\n/);
  const start = lines.findIndex((l) => /^paths:/.test(l));
  const out = [];
  for (const line of lines.slice(start + 1)) {
    if (/^\S/.test(line)) break;
    const m = /^ {2}(['"]?)(\/[^'":]*)\1:\s*$/.exec(line);
    if (m) out.push(m[2]);
  }
  return out;
}

/** The '/v1/...' paths a script calls: quoted strings and template literals (a `${...}` is one segment). */
export function calledPaths(source) {
  const found = new Set();
  for (const m of source.matchAll(/(['"])(\/v1\/[^'"\s?#]*)\1/g)) found.add(m[2]);
  for (const m of source.matchAll(/`(\/v1\/[^`\s?#]*)`/g)) found.add(m[1].replace(/\$\{[^}]*\}/g, '{param}'));
  return [...found].sort();
}

export function matches(called, contract) {
  const parts = called.split('/');
  return contract.some((p) => {
    const q = p.split('/');
    return q.length === parts.length && q.every((seg, i) => (/^\{[^}]+\}$/.test(seg) ? parts[i].length > 0 : seg === parts[i]));
  });
}

export function check(root = ROOT) {
  const contract = contractPaths(readFileSync(join(root, 'packages', 'openapi', 'openapi.yaml'), 'utf8'));
  const dir = join(root, 'apps', 'web');
  const problems = [];
  let n = 0;
  for (const f of readdirSync(dir).filter((x) => x.endsWith('.js'))) {
    for (const p of calledPaths(readFileSync(join(dir, f), 'utf8'))) {
      n += 1;
      if (!matches(p, contract)) problems.push(`${f}: ${p}`);
    }
  }
  return { n, problems };
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  const { n, problems } = check();
  for (const p of problems) console.error(`::error file=apps/web/${p.split(':')[0]}::${p.split(': ')[1]} is not in the published contract`);
  if (problems.length) process.exit(1);
  console.log(`apps/web calls ${n} path(s), all in the published contract.`);
}
