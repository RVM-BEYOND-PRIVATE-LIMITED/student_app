// The RVM Student web version (student_app #7), started against the same
// published contract as the app. It keeps the session in httpOnly cookies the
// API sets and sends no token from JavaScript.
const base = localStorage.getItem('student.api') || 'https://student-api.rvmcad.org';
const app = document.getElementById('app');
const status = document.getElementById('status');
let account = null;

const key = () => crypto.randomUUID();
const json = (r) => r.json();

async function call(path, { method = 'GET', body } = {}) {
  const headers = { Accept: 'application/json' };
  if (body !== undefined) headers['Content-Type'] = 'application/json';
  if (method !== 'GET') headers['Idempotency-Key'] = key();
  const res = await fetch(`${base}${path}`, {
    method, headers, credentials: 'include',
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data?.error?.message || data?.message || `HTTP ${res.status}`);
  return data?.data ?? data;
}

function view(html) { app.innerHTML = html; }
function escape(value) { return String(value ?? '').replace(/[&<>"']/g, (c) => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])); }

async function theme() {
  try {
    const p = await call('/v1/me/preferences');
    document.documentElement.dataset.theme = p.theme_open ? p.theme : 'light';
  } catch { /* Light stays the default. */ }
}

function signIn() {
  view(`<div class="card"><h1>Sign in</h1>
    <p class="muted-text">Use your own mobile number. The code arrives on WhatsApp, or by SMS.</p>
    <div class="row"><input id="phone" class="grow" placeholder="Mobile number" inputmode="numeric" />
    <button id="send">Send code</button></div>
    <div class="row" id="code-row" hidden><input id="code" class="grow" placeholder="6-digit code" inputmode="numeric" />
    <button id="verify">Verify</button></div>
    <p id="error" class="danger"></p></div>`);
  document.getElementById('send').onclick = async () => {
    try {
      const phone = document.getElementById('phone').value.trim();
      const challenge = await call('/v1/auth/otp/request', { method: 'POST', body: { phone } });
      window._challenge = challenge.challenge_id;
      document.getElementById('code-row').hidden = false;
    } catch (e) { document.getElementById('error').textContent = e.message; }
  };
  document.getElementById('verify').onclick = async () => {
    try {
      const code = document.getElementById('code').value.trim();
      const signed = await call('/v1/auth/otp/verify', {
        method: 'POST',
        body: { challenge_id: window._challenge, code, device: { install_id: localStorage.getItem('student.install') || (localStorage.setItem('student.install', crypto.randomUUID()), localStorage.getItem('student.install')), platform: 'web' } },
      });
      account = signed.account;
      status.textContent = account.phone_masked;
      await theme();
      home();
    } catch (e) { document.getElementById('error').textContent = e.message; }
  };
}

async function home() {
  view(`<div class="card"><h1>Hello</h1>
    <p class="muted-text">${escape(account?.phone_masked || 'Signed in')} · Stage ${escape(account?.stage || 'visitor')}</p>
    <div class="row">
      <button data-go="timetable">Timetable</button>
      <button data-go="fees">Fees</button>
      <button data-go="complaints">Complaints</button>
      <button data-go="videos">Videos</button>
      <button data-go="quizzes">Quizzes</button>
      <button class="secondary" data-go="appearance">Appearance</button>
    </div></div><div id="panel"></div>`);
  document.querySelectorAll('[data-go]').forEach((b) => b.onclick = () => go(b.dataset.go));
}

async function go(name) {
  const panel = document.getElementById('panel');
  try {
    if (name === 'timetable') return renderList(panel, 'My classes', '/v1/me/timetable', 'classes', (c) => `${escape(c.date)} · ${escape(c.start_time)}–${escape(c.end_time)} · ${escape(c.faculty_name || '')}`);
    if (name === 'fees') return renderFees(panel);
    if (name === 'complaints') return renderList(panel, 'Complaints', '/v1/me/complaints', 'complaints', (c) => `${escape(c.ref)} · ${escape(c.status)} · ${escape(c.description)}`);
    if (name === 'videos') return renderList(panel, 'Videos', '/v1/me/videos', 'videos', (v) => `${escape(v.title)} · views left ${escape(v.views_left)}`);
    if (name === 'quizzes') return renderList(panel, 'Quizzes', '/v1/visitor/quizzes', 'quizzes', (q) => `${escape(q.title)} · ${escape(q.questions)} questions`);
    if (name === 'appearance') return renderAppearance(panel);
  } catch (e) { panel.innerHTML = `<div class="card danger">${escape(e.message)}</div>`; }
}

async function renderList(panel, title, path, keyName, line) {
  const data = await call(path);
  const rows = data[keyName] || [];
  panel.innerHTML = `<div class="card"><h2>${escape(title)}</h2><ul>${rows.map((row) => `<li>${line(row)}</li>`).join('') || '<li class="muted-text">Nothing yet.</li>'}</ul></div>`;
}

async function renderFees(panel) {
  const fees = await call('/v1/me/fees');
  panel.innerHTML = `<div class="card"><h2>Fees</h2>
    <p>Total ₹${(fees.total_paise/100).toFixed(0)} · Paid ₹${(fees.paid_paise/100).toFixed(0)} · Due ₹${(fees.due_paise/100).toFixed(0)}</p>
    <ul>${(fees.plan || []).map((p) => `<li>${escape(p.due_date)} · ${escape(p.status)} · ₹${(p.balance_due_paise/100).toFixed(0)}</li>`).join('')}</ul></div>`;
}

async function renderAppearance(panel) {
  const p = await call('/v1/me/preferences');
  if (!p.theme_open) { panel.innerHTML = `<div class="card"><h2>Appearance</h2><p class="muted-text">Light is the only theme open to you.</p></div>`; return; }
  panel.innerHTML = `<div class="card"><h2>Appearance</h2><div class="row">
    ${['light','dark','system'].map((t) => `<button class="${p.theme === t ? '' : 'secondary'}" data-theme="${t}">${t}</button>`).join('')}
    </div><p class="muted-text">System follows your phone or browser.</p></div>`;
  panel.querySelectorAll('[data-theme]').forEach((b) => b.onclick = async () => {
    const saved = await call('/v1/me/preferences', { method: 'PUT', body: { theme: b.dataset.theme } });
    document.documentElement.dataset.theme = saved.theme;
    renderAppearance(panel);
  });
}

signIn();
