#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_ROOT="$(pwd)"
/usr/bin/time -p bash -c 'echo "project root: $0"' "$PROJECT_ROOT"
/usr/bin/time -p bash -c 'echo "PORT=${PORT:-3000}"'
PORT="${PORT:-3000}"
export PORT
/usr/bin/time -p bash -c 'echo "exported PORT=$PORT"'
DIST="$PROJECT_ROOT/dist"
/usr/bin/time -p bash -c 'echo "dist: $0"' "$DIST"
/usr/bin/time -p node --version
/usr/bin/time -p npm --version
if /usr/bin/time -p test -f "$PROJECT_ROOT/package.json"; then
  if /usr/bin/time -p test -f "$PROJECT_ROOT/package-lock.json"; then
    /usr/bin/time -p npm ci --no-audit --no-fund
  else
    /usr/bin/time -p npm install --no-audit --no-fund
  fi
  if /usr/bin/time -p node -e "process.exit(JSON.parse(require('fs').readFileSync('package.json','utf8')).scripts?.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
else
  /usr/bin/time -p mkdir -p "$DIST"
  if /usr/bin/time -p test -f "$PROJECT_ROOT/index.html"; then
    /usr/bin/time -p cp "$PROJECT_ROOT/index.html" "$DIST/index.html"
  fi
fi
/usr/bin/time -p mkdir -p "$DIST"
/usr/bin/time -p test -f "$DIST/index.html"
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p node -e "const fs=require('fs');const web='$WEB_DIR';const project=process.argv[1];const directory=process.argv[2];fs.mkdirSync(web,{recursive:true});fs.writeFileSync(web+'/deployment-output.json',JSON.stringify({project,directory}));console.log('wrote '+web+'/deployment-output.json');" "$PROJECT_ROOT" "$DIST"
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p node "$PROJECT_ROOT/scripts/serve.mjs" "$DIST"
