#!/usr/bin/env bash
# Guard against two mistakes that quietly hurt the site and the repository:
#  1. Working files committed to the repo root (slide sources, drafts, PDFs).
#     Jekyll copies any root file it does not exclude into _site, so a stray
#     .pptx or draft would be published. PDFs belong under assets/pdf/.
#  2. Tracked files above a size limit. Every revision of a large binary
#     stays in git history forever; compress PDFs first (scripts/compress_pdf.sh).
# Usage: scripts/check_repo_hygiene.sh [REPO_DIR] [MAX_SIZE_MB]   (defaults: ., 20)
set -euo pipefail

REPO_DIR="${1:-.}"
MAX_MB="${2:-20}"
MAX_BYTES=$(( MAX_MB * 1024 * 1024 ))

if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "'$REPO_DIR' is not a git work tree." >&2
  exit 1
fi

status=0
stray=$(git -C "$REPO_DIR" ls-files -z | tr '\0' '\n' \
  | grep -Ev '/' \
  | grep -Ei '\.(pdf|pptx?|docx?|key|zip)$|-draft\.md$' || true)
if [[ -n "$stray" ]]; then
  echo "❌ Working files tracked in the repository root (move PDFs to assets/pdf/, keep the rest out of git):" >&2
  sed 's/^/  - /' <<< "$stray" >&2
  status=1
fi

large=$(git -C "$REPO_DIR" ls-files -z | while IFS= read -r -d '' f; do
  path="$REPO_DIR/$f"
  [[ -f "$path" ]] || continue
  size=$(wc -c < "$path")
  if (( size > MAX_BYTES )); then
    printf '%s (%d MB)\n' "$f" $(( size / 1024 / 1024 ))
  fi
done)
if [[ -n "$large" ]]; then
  echo "❌ Tracked files larger than ${MAX_MB} MB:" >&2
  sed 's/^/  - /' <<< "$large" >&2
  echo "Compress PDFs with scripts/compress_pdf.sh before committing, or host the file outside the repository." >&2
  status=1
fi

if (( status == 0 )); then
  echo "✅ No stray root files and no tracked file above ${MAX_MB} MB."
fi
exit $status
