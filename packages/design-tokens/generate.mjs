#!/usr/bin/env node
// Generates the Dart constants and the CSS variables from student.tokens.json.
// Run from the repository root: node packages/design-tokens/generate.mjs
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const tokens = JSON.parse(readFileSync(join(here, 'student.tokens.json'), 'utf8'));
const themes = ['light', 'dark'];

/** "#AARRGGBB" or "#RRGGBB" as a Dart int literal. */
function argb(hex) {
  const value = hex.replace('#', '').toUpperCase();
  return value.length === 8 ? `0x${value}` : `0xFF${value}`;
}

/** CSS keeps #RRGGBB when opaque, #AARRGGBB becomes rgba(). */
function css(hex) {
  const value = hex.replace('#', '').toUpperCase();
  if (value.length !== 8) return `#${value}`;
  const a = parseInt(value.slice(0, 2), 16) / 255;
  const r = parseInt(value.slice(2, 4), 16);
  const g = parseInt(value.slice(4, 6), 16);
  const b = parseInt(value.slice(6, 8), 16);
  return `rgba(${r}, ${g}, ${b}, ${Number(a.toFixed(3))})`;
}

const roles = Object.keys(tokens.light).sort();
for (const theme of themes) {
  const missing = roles.filter((role) => !(role in tokens[theme]));
  if (missing.length) throw new Error(`${theme} is missing: ${missing.join(', ')}`);
}

const dart = `// GENERATED FILE — do not edit by hand.
// Source: packages/design-tokens/student.tokens.json
// Regenerate: node packages/design-tokens/generate.mjs
//
// ARGB integers, because this file is imported by the theme only; the
// StudentPalette turns them into Colours.
abstract final class StudentTokenValues {
${themes
  .map(
    (theme) => `  static const ${theme} = <String, int>{
${roles.map((role) => `    '${role}': ${argb(tokens[theme][role])},`).join('\n')}
  };`,
  )
  .join('\n\n')}
}
`;

const cssBody = (theme, indent = '') =>
  roles
    .map((role) => `${indent}--student-${role.replace(/[A-Z]/g, (c) => `-${c.toLowerCase()}`)}: ${css(tokens[theme][role])};`)
    .join('\n');

const stylesheet = `/* GENERATED FILE — do not edit by hand.
 * Source: packages/design-tokens/student.tokens.json
 * Regenerate: node packages/design-tokens/generate.mjs
 */
:root {
${cssBody('light', '  ')}
}

[data-theme='dark'] {
${cssBody('dark', '  ')}
}

@media (prefers-color-scheme: dark) {
  :root:not([data-theme='light']) {
${cssBody('dark', '    ')}
  }
}
`;

const dartPath = join(here, '..', '..', 'mobile', 'lib', 'theme', 'student_tokens.g.dart');
const cssPath = join(here, 'student.tokens.css');
writeFileSync(dartPath, dart);
writeFileSync(cssPath, stylesheet);
console.log(`wrote ${dartPath}`);
console.log(`wrote ${cssPath}`);
