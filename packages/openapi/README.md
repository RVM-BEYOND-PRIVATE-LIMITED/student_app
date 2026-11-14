# The Student API contract

`openapi.yaml` is the contract the RVM Student app (`mobile/`) and its web version are built
against. It is a **copy**: the Student API is built in the backend repository, and the backend's
contract is the source of truth. This copy never leads.

**Status: 0.1.0 is published** (14 Nov 2026): the Stage 1A `/v1` surface. Each route says
`x-status: live` (served now) or `planned` (contract only, 404 until its backend issue ships).

## Publishing a new version

Each publish is one pull request in this repository that:

1. replaces `openapi.yaml` with the backend's contract, `/v1` paths for the app and the web
   version only;
2. raises `info.version` (additive change: minor; fix to wording or examples: patch);
3. sets `info.x-source-commit` to the backend commit the file was copied from;
4. adds a line to `CHANGELOG.md`.

`contract-ci` checks every pull request that touches this folder: the file lints, a change
comes with a higher version, every path is under `/v1`, and a published contract names its
source commit.

## Rules for the contract

- Every reply has a typed schema. Errors use one shape: `code`, `message`, `details`,
  `request_id`.
- Every mutating call documents the `Idempotency-Key` header. Every call from the app
  documents `X-App-Version`.
- Money fields are integer paise and their names end in `_paise`.
- Named examples exist for every state the app shell needs.

## Checking it locally

```bash
npx @redocly/cli@1.34.5 lint --config packages/openapi/redocly.yaml packages/openapi/openapi.yaml
node packages/openapi/tools/check-contract.mjs
node --test packages/openapi/tools/check-contract.test.mjs
```

## A mock server from the examples

A mock server answers from the examples:

```bash
npx @stoplight/prism-cli@5 mock packages/openapi/openapi.yaml --port 4010
```

Pick a named example with the `Prefer` header, for example
`Prefer: example=visitor`. Point the app at it with the dev configuration described in
`mobile/README.md`.

## Generating the Dart client

The generator and its command are decided with the app foundation (student_app #1) and are
written in `mobile/README.md`. The client is generated from this file with no hand edits.
