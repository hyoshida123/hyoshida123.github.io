#!/usr/bin/env bash
# Local build inside WSL. Uses ~/.local/node22 if node is not already on PATH.
set -euo pipefail

if ! command -v node >/dev/null 2>&1; then
  export PATH="$HOME/.local/node22/bin:$PATH"
fi

cd "$(dirname "$0")/.."
node --version
if [ ! -d node_modules ]; then
  npm install --no-fund --no-audit
fi
npm run build
