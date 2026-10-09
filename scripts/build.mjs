import { mkdirSync, copyFileSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const src = join(root, 'index.html');
const dist = join(root, 'dist');
mkdirSync(dist, { recursive: true });
if (!existsSync(src)) throw new Error('Missing index.html source');
copyFileSync(src, join(dist, 'index.html'));
console.log(`Built ${dist}/index.html`);
