# RVM Student web version (student_app #7)

A first, dependency-free web client for iPhone and laptop students. It uses
the same published Student API contract (`packages/openapi/openapi.yaml`) and
the generated CSS variables in `packages/design-tokens/student.tokens.css`.
It is served as static files; there is no build step yet.

Open `index.html` from a static server (for example
`python3 -m http.server` from the repository root) or add a host in front of
it. `localStorage.student.api` overrides the API base; the default is
`https://student-api.rvmcad.org`.

Started: phone/OTP sign-in with the web session cookie, Home, timetable, fees,
complaints, videos, quizzes and the Appearance choice. Still to do: the Join
flow, receipts/payment checkout, community, placement proof, learning player,
push/notifications and the host/CORS/one-session setup in Scheduler_Backend
#159. Those are the remaining #7 items, not hidden work.
