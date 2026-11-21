// student_app #14: the release notes come from the version's CHANGELOG section.
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { sectionOf } from './changelog-section.mjs';

const md = '# Contract changelog\n\nIntro.\n\n## 0.26.0 (16 Nov 2026)\n\nAdds one path.\n\n## 0.25.0 (15 Nov 2026)\n\nThe full surface.\n';

test('the section of one version, up to the next heading', () => {
  assert.equal(sectionOf(md, '0.26.0'), 'Adds one path.');
  assert.equal(sectionOf(md, '0.25.0'), 'The full surface.');
});

test('a version with no section gives null, and 0.2.0 never matches 0.26.0', () => {
  assert.equal(sectionOf(md, '0.9.9'), null);
  assert.equal(sectionOf(md, '0.2.0'), null);
});

test('only a version of three whole numbers is looked up; anything else is refused, never used as a pattern (#91)', () => {
  for (const bad of ['0.2*.0', '.*', '0.26', '0.26.0.1', '0\\.26\\.0', '(a+)+$', '', ' 0.26.0', undefined, null, 26]) {
    assert.equal(sectionOf(md, bad), null, String(bad));
  }
});

test('the published changelog has a section for the published version', () => {
  const contract = readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8');
  const version = /^\s{2}version:\s*['"]?([0-9.]+)/m.exec(contract)[1];
  const changelog = readFileSync(new URL('../CHANGELOG.md', import.meta.url), 'utf8');
  assert.ok(sectionOf(changelog, version), `CHANGELOG.md has no section for ${version}`);
});
