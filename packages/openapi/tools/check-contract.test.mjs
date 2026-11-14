// node --test packages/openapi/tools/check-contract.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { check, versionOf, pathsOf } from './check-contract.mjs';

const doc = (version, paths, commit = 'null') => `openapi: 3.1.0
info:
  title: T
  version: ${version}
  x-source-commit: ${commit}
paths:${paths.length ? '' : ' {}'}
${paths.map((p) => `  ${p}:\n    get:\n      operationId: x`).join('\n')}
components: {}
`;

test('reads the version and the paths', () => {
  const text = doc('1.2.3', ['/v1/config', '/v1/me'], 'abc1234');
  assert.equal(versionOf(text), '1.2.3');
  assert.deepEqual(pathsOf(text), ['/v1/config', '/v1/me']);
});

test('an unpublished contract with no path passes', () => {
  assert.deepEqual(check(doc('0.0.0', []), null), []);
});

test('a path outside /v1 fails', () => {
  const problems = check(doc('1.0.0', ['/v1/config', '/internal/campus'], 'abc1234'), null);
  assert.equal(problems.length, 1);
  assert.match(problems[0], /outside \/v1/);
});

test('a change without a version bump fails, and with one passes', () => {
  const before = doc('1.0.0', ['/v1/config'], 'abc1234');
  const sameVersion = doc('1.0.0', ['/v1/config', '/v1/me'], 'abc1234');
  const bumped = doc('1.1.0', ['/v1/config', '/v1/me'], 'def5678');
  assert.match(check(sameVersion, before)[0], /did not go up/);
  assert.deepEqual(check(bumped, before), []);
  assert.deepEqual(check(before, before), []);
});

test('a published contract must name its source commit', () => {
  assert.match(check(doc('1.0.0', ['/v1/config']), null)[0], /x-source-commit/);
});
