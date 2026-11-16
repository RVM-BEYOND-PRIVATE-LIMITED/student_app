/* eslint-disable no-console */
/**
 * Secret scan (#139 item 4). Reads every file git tracks and fails when one holds something that must never be
 * committed: a private key, a live Razorpay key, a Supabase service-role key, a cloud or GitHub token, a mail API key,
 * a password hash, rows of a database dump, or a tracked .env file.
 *
 * It prints the file, the line and the rule's name, NEVER the value it found, so the CI log cannot leak what it caught.
 *
 * Files already known to be exposed, and waiting for Prakash's decision on rewriting history (#139 item 3, #270), are
 * listed in scripts/secretScan.allow.json with the issue that tracks them; they are skipped, and a listed file that no
 * longer exists is reported so the list can shrink. Anything else that matches fails the build.
 *
 *   node scripts/secretScan.cjs            scan the tracked tree (CI)
 *   node scripts/secretScan.cjs <files..>  scan only these files (still honours the allow list)
 */

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');

/** A JWT whose payload says it is a Supabase service-role key (the anon key is public by design and is not flagged). */
function isServiceRoleJwt(token) {
  try {
    const payload = JSON.parse(Buffer.from(token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/'), 'base64').toString('utf8'));
    return payload && payload.role === 'service_role' && payload.iss === 'supabase';
  } catch {
    return false;
  }
}

const RULES = [
  { name: 'private_key', re: /-----BEGIN (?:RSA |EC |DSA |OPENSSH |ENCRYPTED |PGP )?PRIVATE KEY(?: BLOCK)?-----/ },
  { name: 'razorpay_live_key', re: /\brzp_live_[A-Za-z0-9]{14,}\b/ },
  { name: 'aws_access_key', re: /\b(?:AKIA|ASIA)[0-9A-Z]{16}\b/ },
  { name: 'google_api_key', re: /\bAIza[0-9A-Za-z_-]{35}\b/ },
  { name: 'github_token', re: /\b(?:gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{60,})\b/ },
  { name: 'slack_token', re: /\bxox[abprs]-[A-Za-z0-9-]{10,}/ },
  { name: 'zeptomail_key', re: /Zoho-enczapikey\s+[A-Za-z0-9+/=]{20,}/ },
  { name: 'password_hash', re: /\$2[aby]\$\d{2}\$[./A-Za-z0-9]{53}/ },
  // pg_dump's data section: a dump with rows (users, tokens, phones) is personal data, whatever else it holds.
  { name: 'database_dump_data', re: /^COPY [\w."]+ \([^)]*\) FROM stdin;/ },
  { name: 'supabase_service_key', re: /\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{20,}/g, check: (m) => isServiceRoleJwt(m) },
];

/** A tracked .env file is a finding by its name alone; the examples are not. */
const ENV_FILE = /(^|\/)\.env(\.[A-Za-z0-9_-]+)?$/;
const ENV_OK = /(^|\/)\.env\.(example|sample|template)$/;

/** Findings in one text: [{ line, rule }]. Never the value. */
function scanText(text) {
  const found = [];
  const lines = String(text).split(/\r?\n/);
  lines.forEach((line, i) => {
    for (const rule of RULES) {
      if (rule.check) {
        const matches = line.match(rule.re) || [];
        if (matches.some((m) => rule.check(m))) found.push({ line: i + 1, rule: rule.name });
      } else if (rule.re.test(line)) {
        found.push({ line: i + 1, rule: rule.name });
      }
    }
  });
  return found;
}

/** Findings for one tracked path and its bytes: [{ file, line, rule }]. Binary files (a NUL byte early) are skipped. */
function scanFile(rel, buf) {
  const out = [];
  if (ENV_FILE.test(rel) && !ENV_OK.test(rel)) out.push({ file: rel, line: 0, rule: 'tracked_env_file' });
  if (!buf || buf.subarray(0, 8000).includes(0)) return out;
  for (const f of scanText(buf.toString('utf8'))) out.push({ file: rel, ...f });
  return out;
}

function loadAllow() {
  const p = path.join(__dirname, 'secretScan.allow.json');
  if (!fs.existsSync(p)) return [];
  return (JSON.parse(fs.readFileSync(p, 'utf8')).files || []).map((f) => f.path);
}

function trackedFiles() {
  return execFileSync('git', ['ls-files', '-z'], { cwd: ROOT, maxBuffer: 64 * 1024 * 1024 }).toString('utf8').split('\0').filter(Boolean);
}

function main(argv) {
  const allow = new Set(loadAllow());
  const files = argv.length ? argv.map((f) => path.relative(ROOT, path.resolve(f)).split(path.sep).join('/')) : trackedFiles();
  const findings = [];
  let scanned = 0;
  for (const rel of files) {
    if (allow.has(rel)) continue;
    const abs = path.join(ROOT, rel);
    let buf = null;
    try { buf = fs.statSync(abs).isFile() ? fs.readFileSync(abs) : null; } catch { buf = null; }
    scanned += 1;
    findings.push(...scanFile(rel, buf));
  }
  const tracked = argv.length ? null : new Set(files);
  const stale = tracked ? [...allow].filter((f) => !tracked.has(f)) : [];
  for (const f of stale) console.log(`secret-scan: ${f} is on the allow list but no longer tracked; remove it from scripts/secretScan.allow.json`);
  for (const f of findings) console.log(`secret-scan: ${f.file}${f.line ? `:${f.line}` : ''} ${f.rule}`);
  if (findings.length) {
    console.log(`\nSecret scan FAILED: ${findings.length} finding(s) in ${new Set(findings.map((f) => f.file)).size} file(s). `
      + 'Remove the value, move it to a deploy secret, and treat it as exposed (rotate it).');
    return 1;
  }
  console.log(`Secret scan passed. ${scanned} files scanned, ${allow.size} known file(s) skipped (scripts/secretScan.allow.json).`);
  return 0;
}

if (require.main === module) process.exit(main(process.argv.slice(2)));

module.exports = { scanText, scanFile, isServiceRoleJwt, RULES, main };
