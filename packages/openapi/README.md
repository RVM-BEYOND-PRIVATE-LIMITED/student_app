# The Student API contract

`openapi.yaml` is the contract the RVM Student app (`mobile/`) and its web version are built
against. It is a **copy**: the Student API is built in the backend repository, and the backend's
contract is the source of truth. This copy never leads.

**Status: 0.26.0 is published** (16 Nov 2026): the whole student surface (Stage 1A, Stage 3 and Stage 4) is live in the Scheduler backend; the changelog lists each publish. Each route says
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
source commit. It also fails on a **breaking change** against the last released contract
(`tools/breaking-check.sh`, oasdiff on the bundled JSON; student_app #15): a breaking change gets a
new path and a raised minimum app version instead. And it renders the contract as one page
(`student-api.html`, a download on the run's summary; student_app #16).

## Releases: pinning a version

When a new `info.version` reaches `main`, `contract-release` makes a GitHub release
`contract-v<version>` (student_app #14) with three files: `openapi.yaml` as published, `openapi.json`
(bundled) and `student-api.html` (the rendered page). Its notes are the version's section of
`CHANGELOG.md`. A version is released once; pushing the same version again makes no release.

To build against one version:

```bash
gh release download contract-v0.26.0 --pattern openapi.yaml --dir /tmp/contract   # the pinned file
gh release download contract-v0.26.0 --pattern student-api.html                    # the page to read
```

Locally: `npm run docs` (in this folder) writes `student-api.html`; `npm run breaking` runs the
breaking-change check (needs Docker and `gh`).

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
