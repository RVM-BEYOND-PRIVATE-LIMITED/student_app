// Prints the CHANGELOG.md section of one contract version, for its GitHub release notes
// (student_app #14). Usage: node packages/openapi/tools/changelog-section.mjs 0.26.0
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

export function sectionOf(markdown, version) {
  const lines = markdown.replace(/\r\n/g, '\n').split('\n');
  const start = lines.findIndex((l) => new RegExp(`^## ${version.replace(/\./g, '\\.')}(\\s|$)`).test(l));
  if (start < 0) return null;
  const rest = lines.slice(start + 1);
  const end = rest.findIndex((l) => /^## /.test(l));
  return rest.slice(0, end < 0 ? undefined : end).join('\n').trim();
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  const version = process.argv[2];
  const md = readFileSync(join(dirname(fileURLToPath(import.meta.url)), '..', 'CHANGELOG.md'), 'utf8');
  const body = sectionOf(md, version);
  process.stdout.write(`${body || `Contract ${version}. See CHANGELOG.md.`}\n\nThe file, its bundled JSON and the rendered page are attached. Copied unchanged from Scheduler_Backend; this copy never leads.\n`);
}
