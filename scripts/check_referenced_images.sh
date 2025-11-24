#!/usr/bin/env bash
# Scan built _site HTML for <img> src references to non-WebP images under assets/images.
# Allows storing original PNG/JPG/GIF assets in repo as long as they are not referenced directly.
# Fails if any referenced image ends with .png/.jpg/.jpeg/.gif.
set -euo pipefail

SITE_DIR="_site"
if [[ ! -d "$SITE_DIR" ]]; then
  echo "Built site directory '$SITE_DIR' not found. Run jekyll build first." >&2
  exit 1
fi

html_files=$(find "$SITE_DIR" -type f -name '*.html')
if [[ -z "$html_files" ]]; then
  echo "No HTML files found in $SITE_DIR; nothing to scan." >&2
  exit 0
fi

bad_refs_file=$(mktemp)
trap "rm -f '$bad_refs_file'" EXIT

while IFS= read -r file; do
  # Extract src attributes from img tags
  # Using grep + sed; robust enough for static generated HTML
  grep -oE '<img[^>]*src="[^"]+"' "$file" 2>/dev/null || true | sed -E 's/.*src="([^"]+)"/\1/' | while read -r src; do
    case "$src" in
      *assets/images/*)
        # Use shopt nocasematch for case-insensitive extension matching
        shopt -s nocasematch
        if [[ "$src" =~ \.(png|jpg|jpeg|gif)$ ]]; then
          echo "$src (in ${file#_site/})" >> "$bad_refs_file"
        fi
        shopt -u nocasematch
        ;;
    esac
  done
done <<< "$html_files"

if [[ -s "$bad_refs_file" ]]; then
  echo "❌ Non-WebP image references detected:" >&2
  sed 's/^/  - /' "$bad_refs_file" >&2
  echo "Convert these images to .webp and update the HTML/Markdown references." >&2
  exit 1
fi

echo "✅ All referenced images use WebP (or are outside assets/images)."
