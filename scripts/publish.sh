#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

git add .
git commit -m "Create interactive architecture diagram skill" || true

echo ""
echo "Create an empty GitHub repository, then run:"
echo "  git remote add origin https://github.com/YOUR-USER/interactive-architecture-diagram-skill.git"
echo "  git push -u origin main"
