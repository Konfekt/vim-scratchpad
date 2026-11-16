#!/bin/sh
# Run every test/test_*.vim in a fresh headless instance of each given editor
# (default: vim and nvim, whichever are installed). Exits non-zero on failure.
set -u
cd "$(dirname "$0")/.." || exit 1
[ $# -gt 0 ] || set -- vim nvim
status=0
log=$(mktemp) || exit 1
trap 'rm -f "$log"' EXIT
export SCRATCHPAD_TEST_LOG="$log"
for editor in "$@"; do
  if ! command -v "$editor" >/dev/null 2>&1; then
    echo "skip: $editor not found"
    continue
  fi
  echo "== $editor"
  for t in test/test_*.vim; do
    : >"$log"
    if [ "$(basename "$editor")" = nvim ]; then
      "$editor" --headless --clean -u NONE -i NONE -n -S "$t" >/dev/null 2>&1
    else
      "$editor" -Nu NONE -i NONE -n -es -S "$t" >/dev/null 2>&1
    fi
    if [ "$(cat "$log")" = ok ]; then
      echo "ok   $t"
    else
      echo "FAIL $t"
      sed 's/^/     /' "$log"
      status=1
    fi
  done
done
exit "$status"
