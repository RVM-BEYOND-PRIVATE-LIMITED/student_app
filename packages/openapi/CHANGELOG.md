# Contract changelog

Additive changes stay in v1: new paths, new optional fields, new enum values the app already
tolerates. A breaking change is never made in place: it gets a new path and a raised minimum
app version, and the old path keeps working until that version is enforced.

## 0.1.0 (14 Nov 2026)

First published contract, from the Student API foundation (Scheduler_Backend #158, commit
8aa49d1). The whole Stage 1A `/v1` surface: config, sign-in, me, linking, consents and the age
tick, Jobs access, the Campus hand-off, placement prompts and consent requests. Named examples for
every state the app shell needs. Live on the server today: `GET /v1/config`, `GET /v1/me`,
`PUT /v1/me/language` (`x-status: live`); the rest answer 404 until their backend issue ships.

## 0.0.0

Nothing published. The scaffold's generated file (28 October 2026) was removed: it described
a design that was replaced.
