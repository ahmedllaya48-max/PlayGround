import { createServer } from 'node:http';
import { readFileSync, existsSync, statSync } from 'node:fs';
import { resolve, join, extname } from 'node:path';

const root = process.argv[2] || join(process.cwd(), 'dist');
const port = Number(process.env.PORT || 3000);
const dir = resolve(root);
if (!existsSync(join(dir, 'index.html'))) {
  console.error(`Static deployment output must contain index.html: ${dir}`);
  process.exit(1);
}
const mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
  '.txt': 'text/plain; charset=utf-8'
};
const server = createServer((req, res) => {
  try {
    const url = new URL(req.url || '/', 'http://localhost');
    let path = resolve(dir, '.' + decodeURIComponent(url.pathname));
    if (path !== dir && !path.startsWith(dir + '/')) {
      res.writeHead(404); res.end('Not found'); return;
    }
    try {
      if (statSync(path).isDirectory()) path = join(path, 'index.html');
    } catch {
      path = join(dir, 'index.html');
    }
    if (!existsSync(path)) path = join(dir, 'index.html');
    res.setHeader('Content-Type', mime[extname(path)] || 'application/octet-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.end(readFileSync(path));
  } catch {
    res.writeHead(404); res.end('Not found');
  }
});
server.listen(port, '0.0.0.0', () => console.log(`Serving ${dir} on :${port}`));
