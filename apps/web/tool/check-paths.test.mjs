import test from 'node:test';
import assert from 'node:assert/strict';
import { calledPaths, contractPaths, matches, check } from './check-paths.mjs';

const contract = contractPaths('openapi: 3.1.0\npaths:\n  /v1/me/fees:\n    get: {}\n  /v1/me/complaints/{id}/reopen:\n    post: {}\ncomponents: {}\n');

test('reads the contract paths', () => {
  assert.deepEqual(contract, ['/v1/me/fees', '/v1/me/complaints/{id}/reopen']);
});

test('finds quoted and template paths; a template part is one segment', () => {
  const src = "api('/v1/me/fees'); api(`/v1/me/complaints/${id}/reopen`); const x = \"/v1/me/fees?x=1\";";
  assert.deepEqual(calledPaths(src), ['/v1/me/complaints/{param}/reopen', '/v1/me/fees']);
});

test('matches a parameter segment, never a different length or name', () => {
  assert.equal(matches('/v1/me/complaints/{param}/reopen', contract), true);
  assert.equal(matches('/v1/me/complaints/{param}', contract), false);
  assert.equal(matches('/v1/me/feez', contract), false);
});

test('the web version calls only what the published contract has', () => {
  const { n, problems } = check();
  assert.ok(n > 0);
  assert.deepEqual(problems, []);
});
