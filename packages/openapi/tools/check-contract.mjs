// Guards for the published contract (student_app #10 item 7). No dependencies: the file is
// read as text, because the three checks only need a few well-known lines.
//
//   1. A change to openapi.yaml comes with a higher info.version (compared with BASE_SHA).
//   2. Every path is under /v1.
//   3. A published contract (version above 0.0.0) names the backend commit it was copied from.
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';

const FILE = 'packages/openapi/openapi.yaml';
const fail = (message) => { console.error(`::error file=${FILE}::${message}`); process.exitCode = 1; };

export const versionOf = (text) => (/^\s{2}version:\s*['"]?([0-9]+\.[0-9]+\.[0-9]+)['"]?\s*$/m.exec(text) || [])[1] || null;
export const pathsOf = (text) => {
  const lines = text.split(/\r?\n/);
  const start = lines.findIndex((l) => /^paths:/.test(l));
  if (start < 0) return [];
  const out = [];
  for (const line of lines.slice(start + 1)) {
    if (/^\S/.test(line)) break;
    const m = /^ {2}(['"]?)(\/[^'":]*)\1:\s*$/.exec(line);
    if (m) out.push(m[2]);
  }
  return out;
};
export const sourceCommitOf = (text) => (/^\s{2}x-source-commit:\s*['"]?([0-9a-f]{7,40})['"]?\s*$/m.exec(text) || [])[1] || null;
export const newer = (a, b) => {
  const x = a.split('.').map(Number);
  const y = b.split('.').map(Number);
  for (let i = 0; i < 3; i += 1) if (x[i] !== y[i]) return x[i] > y[i];
  return false;
};

export function check(current, previous) {
  const problems = [];
  const version = versionOf(current);
  if (!version) problems.push('info.version must be three numbers, for example 1.4.0.');
  for (const p of pathsOf(current)) {
    if (!/^\/v1\//.test(p)) problems.push(`Path ${p} is outside /v1. The app and the web version use /v1 only.`);
  }
  if (version && version !== '0.0.0' && !sourceCommitOf(current)) {
    problems.push('info.x-source-commit must name the backend commit this contract was copied from.');
  }
  if (previous !== null && previous !== current) {
    const before = versionOf(previous);
    if (version && before && !newer(version, before)) {
      problems.push(`The contract changed but info.version did not go up (${before} -> ${version}). Raise the version in the same pull request.`);
    }
  }
  return problems;
}

const isMain = process.argv[1] && import.meta.url.endsWith(process.argv[1].replace(/\\/g, '/').split('/').pop());
if (isMain) {
  const current = readFileSync(FILE, 'utf8');
  let previous = null;
  const base = process.env.BASE_SHA;
  if (base) {
    try {
      previous = execFileSync('git', ['show', `${base}:${FILE}`], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] });
    } catch {
      previous = null; // The file did not exist on the base branch.
    }
  }
  const problems = check(current, previous);
  problems.forEach(fail);
  if (!problems.length) console.log(`Contract ${versionOf(current)}: ${pathsOf(current).length} path(s), all under /v1.`);
}
