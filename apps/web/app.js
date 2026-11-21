// The RVM Student web version (student_app #7), started against the same
// published contract as the app. It keeps the session in httpOnly cookies the
// API sets and sends no token from JavaScript.
const base = localStorage.getItem('student.api') || 'https://student-api.rvmcad.org';
const app = document.getElementById('app');
const status = document.getElementById('status');
let account = null;

// #87 — a website link may ask for Join (with courses) or Jobs. Keep the
// request through sign-in, then remove it from the address bar so a reload
// does not repeat it.
function readIntent() {
  const params = new URLSearchParams(window.location.search);
  const go = params.get('go');
  const courses = (params.get('course') || '')
    .split(',').map((id) => id.trim()).filter(Boolean);
  if (params.has('go') || params.has('course')) {
    params.delete('go');
    params.delete('course');
    const rest = params.toString();
    history.replaceState({}, '', `${location.pathname}${rest ? `?${rest}` : ''}${location.hash}`);
  }
  return { go, courses };
}
let pendingIntent = readIntent();

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
      await afterSignIn();
    } catch (e) { document.getElementById('error').textContent = e.message; }
  };
}

function afterSignIn() {
  const intent = pendingIntent;
  pendingIntent = null;
  home();
  if (intent.go === 'join') return go('join', intent.courses);
  if (intent.go === 'jobs') return go('jobs');
}

async function home() {
  stopPlayback();
  view(`<div class="card"><h1>Hello</h1>
    <p class="muted-text">${escape(account?.phone_masked || 'Signed in')} · Stage ${escape(account?.stage || 'visitor')}</p>
    <div class="row">
      <button data-go="timetable">Timetable</button>
      <button data-go="fees">Fees</button>
      <button data-go="complaints">Complaints</button>
      <button data-go="videos">Videos</button>
      <button data-go="quizzes">Quizzes</button>
      <button data-go="receipts">Receipts</button>
      <button data-go="join">Join</button>
      <button data-go="jobs">Jobs</button>
      <button data-go="profile">Profile</button>
      <button class="secondary" data-go="appearance">Appearance</button>
    </div></div><div id="panel"></div>`);
  document.querySelectorAll('[data-go]').forEach((b) => b.onclick = () => go(b.dataset.go));
}

async function go(name, courses = []) {
  stopPlayback();
  const panel = document.getElementById('panel');
  try {
    if (name === 'timetable') return renderList(panel, 'My classes', '/v1/me/timetable', 'classes', (c) => `${escape(c.date)} · ${escape(c.start_time)}–${escape(c.end_time)} · ${escape(c.faculty_name || '')}`);
    if (name === 'fees') return renderFees(panel);
    if (name === 'complaints') return renderComplaints(panel);
    if (name === 'videos') return renderVideos(panel);
    if (name === 'quizzes') return renderList(panel, 'Quizzes', '/v1/visitor/quizzes', 'quizzes', (q) => `${escape(q.title)} · ${escape(q.questions)} questions`);
    if (name === 'receipts') return renderReceipts(panel);
    if (name === 'join') return renderJoin(panel, courses);
    if (name === 'jobs') return renderJobs(panel);
    if (name === 'profile') return renderProfile(panel);
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

async function renderReceipts(panel) {
  const data = await call('/v1/me/receipts');
  const rows = data.receipts || [];
  panel.innerHTML = `<div class="card"><h2>Receipts</h2><ul>${rows.map((r) => `<li>${escape(r.receipt_number)} · ₹${(r.amount_paise/100).toFixed(0)} · ${escape(r.payment_date)} <button class="secondary" data-receipt="${escape(r.id)}">PDF</button></li>`).join('') || '<li class="muted-text">No receipts yet.</li>'}</ul></div>`;
  panel.querySelectorAll('[data-receipt]').forEach((b) => b.onclick = async () => {
    try {
      const pdf = await call(`/v1/me/receipts/${b.dataset.receipt}/pdf`);
      const bytes = Uint8Array.from(atob(pdf.pdf_base64), (c) => c.charCodeAt(0));
      const url = URL.createObjectURL(new Blob([bytes], { type: 'application/pdf' }));
      const a = document.createElement('a');
      a.href = url; a.download = pdf.filename || 'receipt.pdf'; a.click();
      URL.revokeObjectURL(url);
    } catch (e) { b.textContent = e.message; }
  });
}

async function renderComplaints(panel) {
  const data = await call('/v1/me/complaints');
  const rows = data.complaints || [];
  panel.innerHTML = `<div class="card"><h2>Complaints</h2>
    <div class="row"><input id="c-cat" class="grow" placeholder="Category" /><input id="c-desc" class="grow" placeholder="What happened?" /><button id="c-send">Raise</button></div>
    <p id="c-error" class="danger"></p><ul>${rows.map((c) => `<li><button class="secondary" data-complaint="${escape(c.id)}">${escape(c.ref)} · ${escape(c.status)}</button> ${escape(c.description)}</li>`).join('') || '<li class="muted-text">No complaints.</li>'}</ul></div><div id="thread"></div>`;
  document.getElementById('c-send').onclick = async () => {
    try {
      await call('/v1/me/complaints', { method: 'POST', body: { category: document.getElementById('c-cat').value.trim(), description: document.getElementById('c-desc').value.trim() } });
      renderComplaints(panel);
    } catch (e) { document.getElementById('c-error').textContent = e.message; }
  };
  panel.querySelectorAll('[data-complaint]').forEach((b) => b.onclick = () => renderComplaint(b.dataset.complaint));
}

async function renderComplaint(id) {
  const thread = document.getElementById('thread');
  try {
    const data = await call(`/v1/me/complaints/${id}`);
    const c = data.complaint || data;
    const messages = data.messages || [];
    thread.innerHTML = `<div class="card"><h2>${escape(c.ref)} · ${escape(c.status)}</h2><p>${escape(c.description)}</p>
      <ul>${messages.map((m) => `<li>${escape(m.body || m.message || '')}</li>`).join('')}</ul>
      <div class="row"><input id="m-body" class="grow" placeholder="Write a message" /><button id="m-send">Send</button></div>
      ${c.can_reopen ? '<button id="c-reopen" class="secondary">Reopen</button>' : ''}</div>`;
    document.getElementById('m-send').onclick = async () => {
      await call(`/v1/me/complaints/${id}/messages`, { method: 'POST', body: { body: document.getElementById('m-body').value.trim() } });
      renderComplaint(id);
    };
    const reopen = document.getElementById('c-reopen');
    if (reopen) reopen.onclick = async () => { await call(`/v1/me/complaints/${id}/reopen`, { method: 'POST', body: {} }); renderComplaint(id); };
  } catch (e) { thread.innerHTML = `<div class="card danger">${escape(e.message)}</div>`; }
}

async function renderJoin(panel, selectedCourses = []) {
  const selected = new Set(selectedCourses.map(String));
  let registration = null;
  try { registration = await call('/v1/me/registrations'); } catch { /* No registration yet. */ }
  const courses = await call('/v1/courses');
  const branches = await call('/v1/branches');
  panel.innerHTML = `<div class="card"><h2>Join RVM</h2>
    ${registration ? `<p>Registration status: ${escape(registration.status)}</p><p>Total ₹${(registration.total_paise/100).toFixed(0)}</p><p class="muted-text">Open the Android app to finish the ID upload and the undertaking.</p>` : `
    <div class="row"><select id="j-branch">${(branches.branches || []).map((b) => `<option value="${escape(b.id)}">${escape(b.name)}</option>`).join('')}</select></div>
    <div class="row"><input id="j-name" class="grow" placeholder="Full name" /><input id="j-email" class="grow" placeholder="Email" /></div>
    <div class="row"><input id="j-dob" class="grow" placeholder="Date of birth (YYYY-MM-DD)" /><input id="j-father" class="grow" placeholder="Father's name" /></div>
    <div class="row"><input id="j-current" class="grow" placeholder="Current address" /><input id="j-permanent" class="grow" placeholder="Permanent address" /></div>
    <div class="row"><input id="j-father-phone" class="grow" placeholder="Father's phone" /></div>
    <ul>${(courses.courses || []).map((c) => `<li><label><input type="checkbox" value="${escape(c.id)}" ${selected.has(String(c.id)) ? 'checked' : ''} /> ${escape(c.name)} · ₹${(c.price_paise/100).toFixed(0)}</label></li>`).join('')}</ul>
    <button id="j-save">Save and continue</button><p id="j-error" class="danger"></p>`}</div>`;
  const save = document.getElementById('j-save');
  if (!save) return;
  save.onclick = async () => {
    try {
      const course_ids = [...panel.querySelectorAll('input[type=checkbox]:checked')].map((c) => c.value);
      await call('/v1/me/registrations', { method: 'POST', body: {
        branch_id: Number(document.getElementById('j-branch').value),
        student_name: document.getElementById('j-name').value.trim(),
        email: document.getElementById('j-email').value.trim(),
        date_of_birth: document.getElementById('j-dob').value.trim(),
        current_address: document.getElementById('j-current').value.trim(),
        permanent_address: document.getElementById('j-permanent').value.trim(),
        father_name: document.getElementById('j-father').value.trim(),
        father_phone: document.getElementById('j-father-phone').value.trim(),
        course_ids,
      } });
      renderJoin(panel);
    } catch (e) { document.getElementById('j-error').textContent = e.message; }
  };
}

let playbackTimer = null;
let playbackElapsed = null;
let playbackSession = null;

/** #85 — RVM's own stream in a plain <video>, with a moving watermark and no
 * download, share, cast or picture-in-picture control. */
async function renderVideos(panel) {
  const data = await call('/v1/me/videos');
  const rows = data.videos || [];
  panel.innerHTML = `<div class="card"><h2>Videos</h2><ul>${rows.map((v) => `<li>${escape(v.title)} · views left ${escape(v.views_left)} ${v.locked_reason ? `<span class="muted-text">(${escape(v.locked_reason)})</span>` : `<button class="secondary" data-video="${escape(v.id)}">Play</button>`}</li>`).join('') || '<li class="muted-text">Nothing yet.</li>'}</ul></div><div id="player"></div>`;
  panel.querySelectorAll('[data-video]').forEach((b) => b.onclick = () => openVideo(b.dataset.video));
}

async function openVideo(videoId) {
  const host = document.getElementById('player');
  host.innerHTML = '<div class="card muted-text">Opening…</div>';
  try {
    const session = await call('/v1/playback/sessions', { method: 'POST', body: { video_id: videoId } });
    if (session.provider !== 'self') {
      host.innerHTML = `<div class="card"><h3>Open this video in the app</h3><p class="muted-text">This recording needs the Android app's protected player.</p></div>`;
      return;
    }
    playbackSession = session;
    playbackElapsed = Date.now();
    host.innerHTML = `<div class="card"><div class="player-wrap"><video id="player-video" playsinline controls controlsList="nodownload noremoteplayback noplaybackrate" disablepictureinpicture></video><span id="watermark" class="watermark"></span></div><p id="player-message" class="muted-text"></p></div>`;
    const video = document.getElementById('player-video');
    const mark = document.getElementById('watermark');
    const message = document.getElementById('player-message');
    video.src = session.stream_url;
    video.addEventListener('contextmenu', (e) => e.preventDefault());
    video.addEventListener('ended', () => endPlayback(session.session_id));
    video.addEventListener('error', () => {
      stopPlayback();
      message.textContent = 'This playback has ended. Open the video again.';
    });
    if (session.watermark_text) {
      mark.textContent = session.watermark_text;
      let corner = 0;
      const place = () => {
        const spots = [['12px','12px'],['auto','12px','right'],['12px','auto','bottom'],['auto','auto','right','bottom']];
        const [top, left, ...rest] = spots[corner % spots.length];
        mark.style.top = top; mark.style.left = left;
        mark.style.right = rest.includes('right') ? '12px' : 'auto';
        mark.style.bottom = rest.includes('bottom') ? '12px' : 'auto';
        corner += 1;
      };
      place();
      playbackTimer = setInterval(place, 4000);
    }
    video.play().catch(() => { message.textContent = 'Press play to start.'; });
    startHeartbeat(session);
  } catch (e) {
    host.innerHTML = `<div class="card danger">${escape(e.message)}</div>`;
  }
}

function startHeartbeat(session) {
  const seconds = Math.max(5, Number(session.heartbeat_seconds) || 15) * 1000;
  clearInterval(heartbeatTimer);
  heartbeatTimer = setInterval(async () => {
    const video = document.getElementById('player-video');
    if (!video || !playbackSession) return;
    const elapsed = Math.max(0, Math.round((Date.now() - playbackElapsed) / 1000));
    playbackElapsed = Date.now();
    try {
      const reply = await call(`/v1/playback/sessions/${session.session_id}/heartbeat`, {
        method: 'POST',
        body: { position_s: Math.floor(video.currentTime || 0), elapsed_s: elapsed },
      });
      if (reply.stop) {
        video.pause();
        const message = document.getElementById('player-message');
        if (message) message.textContent = reply.reason === 'replaced'
          ? 'This video was opened somewhere else.'
          : 'This playback has ended. Open the video again.';
        stopPlayback(false);
      }
    } catch { /* The next beat retries; the session stays. */ }
  }, seconds);
}
let heartbeatTimer = null;

function stopPlayback(end = true) {
  if (heartbeatTimer) { clearInterval(heartbeatTimer); heartbeatTimer = null; }
  if (playbackTimer) { clearInterval(playbackTimer); playbackTimer = null; }
  const sessionId = playbackSession?.session_id;
  playbackSession = null;
  if (end && sessionId) endPlayback(sessionId);
}

function endPlayback(sessionId) {
  void call(`/v1/playback/sessions/${sessionId}/end`, { method: 'POST', body: {} }).catch(() => {});
}

window.addEventListener('beforeunload', () => stopPlayback());

async function renderJobs(panel) {
  const access = await call('/v1/me/jobs-access');
  if (!access.allowed) {
    const reason = (access.reasons || [access.reason]).filter(Boolean).join(', ') || 'not open';
    panel.innerHTML = `<div class="card"><h2>Jobs</h2><p class="muted-text">Jobs are closed: ${escape(reason)}.</p></div>`;
    return;
  }
  const handoff = await call('/v1/me/campus-handoff', { method: 'POST' });
  panel.innerHTML = `<div class="card"><h2>Opening Campus…</h2></div>`;
  window.location.assign(handoff.url);
}

async function renderProfile(panel) {
  const profile = await call('/v1/me/profile');
  panel.innerHTML = `<div class="card"><h2>Profile</h2>
    <p>${escape(profile.name || '')} · ${escape(account?.phone_masked || '')}</p>
    <p class="muted-text">Stage ${escape(account?.stage || '')} · Language ${escape(account?.language || 'en')}</p>
    <div class="row"><button data-lang="en" class="secondary">English</button><button data-lang="hi" class="secondary">हिन्दी</button><button id="p-signout" class="secondary">Sign out</button></div>
    <p class="muted-text">Account deletion is in the Android app and the Profile API.</p></div>`;
  panel.querySelectorAll('[data-lang]').forEach((b) => b.onclick = async () => { await call('/v1/me/language', { method: 'PUT', body: { language: b.dataset.lang } }); });
  document.getElementById('p-signout').onclick = async () => { await call('/v1/auth/logout', { method: 'POST', body: {} }); account = null; signIn(); };
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

// While the student app is closed (the student_app switch is off: Student API 0.36.0 `sign_in_open`)
// or under maintenance, show that instead of a sign-in form. If /v1/config cannot be read the form
// shows as before; the API itself still refuses every sign-in while the app is closed.
function notOpen(title, message) {
  view(`<div class="card"><h1>${escape(title)}</h1>
    <p class="muted-text">${escape(message)}</p></div>`);
}

async function start() {
  try {
    const config = await call('/v1/config');
    if (config?.maintenance?.active) {
      notOpen('Back soon', config.maintenance.message || 'The app is being updated. Please try again in a few minutes.');
      return;
    }
    if (config?.sign_in_open === false) {
      notOpen('Not open yet', 'The RVM student app is not open yet. Please check again later.');
      return;
    }
  } catch { /* The form shows; sign-in answers for itself. */ }
  signIn();
}

start();
