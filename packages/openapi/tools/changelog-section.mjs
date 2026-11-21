// Prints the CHANGELOG.md section of one contract version, for its GitHub release notes
// (student_app #14). Usage: node packages/openapi/tools/changelog-section.mjs 0.26.0
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

// A contract version is three whole numbers (1.2.3). Anything else is refused, and the heading is matched as plain
// text, never built into a regular expression (student_app #91).
const VERSION = /^\d+\.\d+\.\d+$/;

export function sectionOf(markdown, version) {
  if (typeof version !== 'string' || !VERSION.test(version)) return null;
  const lines = markdown.replace(/\r\n/g, '\n').split('\n');
  const heading = `## ${version}`;
  const start = lines.findIndex((l) => l === heading || l.startsWith(`${heading} `) || l.startsWith(`${heading}\t`));
  if (start < 0) return null;
  const rest = lines.slice(start + 1);
  const end = rest.findIndex((l) => /^## /.test(l));
  return rest.slice(0, end < 0 ? undefined : end).join('\n').trim();
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  const version = process.argv[2];
  if (!VERSION.test(String(version || ''))) {
    process.stderr.write('Give the contract version as three whole numbers, for example 0.35.1.\n');
    process.exit(1);
  }
  const md = readFileSync(join(dirname(fileURLToPath(import.meta.url)), '..', 'CHANGELOG.md'), 'utf8');
  const body = sectionOf(md, version);
  process.stdout.write(`${body || `Contract ${version}. See CHANGELOG.md.`}\n\nThe file, its bundled JSON and the rendered page are attached. Copied unchanged from Scheduler_Backend; this copy never leads.\n`);
}
