# RVM Student web version (student_app #7)

A first, dependency-free web client for iPhone and laptop students. It uses
the same published Student API contract (`packages/openapi/openapi.yaml`) and
the generated CSS variables in `packages/design-tokens/student.tokens.css`.
It is served as static files; there is no build step yet.

Open `index.html` from a static server (for example
`python3 -m http.server` from the repository root) or add a host in front of
it. `localStorage.student.api` overrides the API base; the default is
`https://student-api.rvmcad.org`.

Started: phone/OTP sign-in with the web session cookie, Home, timetable, fees
and receipts (PDF download), complaints (raise, thread, reply, reopen), the
Join start (courses, branch and details), the Jobs hand-off, profile and
language, videos, quizzes and the Appearance choice. The protected player,
community, placement proof, push and the host/CORS/one-session setup are the
remaining #7 items and are not hidden work.

## Checks and hosting (student_app #20 items 11 and 12)

- `web-ci` runs on every pull request that touches the web version or the contract: the scripts
  parse, every `/v1` path the web version calls is in the published contract
  (`apps/web/tool/check-paths.mjs`), and the files the host serves are all there.
- `web-deploy` publishes the web version on its own host on every push to `main` that touches it.
  `apps/web/deploy/build.sh` copies the three files and the design tokens into one folder. On the
  server: an HTTP-only site until certbot has the certificate, then HTTPS; `nginx -t` before every
  reload, and a failing test removes only this site.
- It deploys nothing until Prakash has added the host's DNS record (proposed `app.rvmcad.org`),
  the repository variable `STUDENT_WEB_HOST` (a secret of that name works too), and the secrets `SERVER_HOST`, `SERVER_USER` and
  `SERVER_SSH_KEY_BASE64` (the private key base64-encoded, or pasted as it is). The Student API must also allow the host as a browser origin (the
  backend's `STUDENT_CORS_ORIGINS`).
