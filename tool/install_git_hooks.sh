#!/usr/bin/env bash
# Run once per clone: use version-controlled hooks from tool/git-hooks/
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
git config core.hooksPath tool/git-hooks
echo "core.hooksPath set to tool/git-hooks (pre-commit runs format, analyze, test)."
