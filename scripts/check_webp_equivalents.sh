#!/usr/bin/env bash
# Ensure every raster source image under assets/images has a sibling .webp file.
# Site layouts, markdown pages, and article figures reference .webp assets
# directly while social-preview and full-resolution originals remain paired
# alongside them in Git.
# This guard fails CI when a new .png/.jpg/.jpeg/.gif is added without a .webp
# twin, matching the non-WebP raster formats in scripts/check_referenced_images.sh.
# Usage: scripts/check_webp_equivalents.sh [IMAGE_DIR]   (default: assets/images)
set -euo pipefail

IMAGE_DIR="${1:-assets/images}"
if [[ ! -d "$IMAGE_DIR" ]]; then
  echo "Image directory '$IMAGE_DIR' not found." >&2
  exit 1
fi

missing_file=$(mktemp)
trap "rm -f '$missing_file'" EXIT

while IFS= read -r img; do
  webp="${img%.*}.webp"
  if [[ ! -f "$webp" ]]; then
    echo "$img (expected $webp)" >> "$missing_file"
  fi
done < <(find "$IMAGE_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) | sort)

if [[ -s "$missing_file" ]]; then
  echo "❌ Raster images without a .webp equivalent:" >&2
  sed 's/^/  - /' "$missing_file" >&2
  echo "Generate a .webp next to each image (e.g. 'convert image.png -quality 90 image.webp')." >&2
  exit 1
fi

echo "✅ Every raster image under $IMAGE_DIR has a .webp equivalent."
