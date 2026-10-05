#!/bin/bash
# publish_web.sh — Export Cantina to web and deploy to cantina.dglabs.cloud
# Usage: bash tools/publish_web.sh
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build/web"
REPO_WEB="/root/projects/cantina-web"

echo "[publish] Building web export..."
cd "$PROJECT_DIR"
godot --headless --path . --export-release "Web" "$BUILD_DIR/index.html"

echo "[publish] Syncing to web repo..."
rsync -a --delete "$BUILD_DIR/" "$REPO_WEB/"

cd "$REPO_WEB"
SHA=$(cd "$PROJECT_DIR" && git rev-parse --short HEAD)
echo "$SHA" > BUILD_INFO.txt
git add -A
git -c user.name="dgl-ai" -c user.email="dgl-ai@users.noreply.github.com" commit -m "deploy: $SHA" || echo "No changes"
git push origin main

echo "[publish] Done — deploy SHA: $SHA"
echo "[publish] Web will update in ~65s (systemd timer)"
