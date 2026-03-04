#!/usr/bin/env bash
set -euo pipefail

IMAGE_DIR="assets/images"
OUTPUT_DIR="${IMAGE_DIR}/optimized"

MAX_WIDTH=1920
BANNER_WIDTH=2560
PROFILE_WIDTH=600
ICON_WIDTH=300
MOBILE_WIDTH=768

RESIZE_QUALITY=85
MOBILE_QUALITY=80
WEBP_QUALITY=80
JPEG_MAX=80
PNG_LEVEL=3

ENABLE_MOBILE=1
APPLY_RESULTS=0
APPLY_ORIGINALS=0

FILES=()

usage() {
  cat <<USAGE
Usage: ./resize_images.sh [options] [file1 file2 ...]

If no files are provided, the script processes all JPG/JPEG/PNG files under ${IMAGE_DIR}
(excluding ${OUTPUT_DIR}).

Options:
  --file <path>         Add a file to process (can be used multiple times)
  --no-mobile           Skip generating *-mobile images for banner-like files
  --webp-quality <n>    WebP quality (default: ${WEBP_QUALITY})
  --apply               Copy generated WebP files from ${OUTPUT_DIR} back into ${IMAGE_DIR}
  --apply-originals     With --apply, also copy optimized JPG/JPEG/PNG outputs back
  -h, --help            Show this help message

Examples:
  ./resize_images.sh
  ./resize_images.sh --file assets/images/banner.jpg --file assets/images/group2025.jpg --apply
  ./resize_images.sh assets/images/members/ChaolongWang.jpg --no-mobile --apply
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)
      [[ $# -ge 2 ]] || { echo "Error: --file requires a value" >&2; exit 1; }
      FILES+=("$2")
      shift 2
      ;;
    --no-mobile)
      ENABLE_MOBILE=0
      shift
      ;;
    --webp-quality)
      [[ $# -ge 2 ]] || { echo "Error: --webp-quality requires a value" >&2; exit 1; }
      WEBP_QUALITY="$2"
      shift 2
      ;;
    --apply)
      APPLY_RESULTS=1
      shift
      ;;
    --apply-originals)
      APPLY_RESULTS=1
      APPLY_ORIGINALS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      FILES+=("$1")
      shift
      ;;
  esac
done

command -v convert >/dev/null 2>&1 || { echo "ImageMagick (convert) is required. Install with: sudo apt-get install imagemagick" >&2; exit 1; }
command -v identify >/dev/null 2>&1 || { echo "ImageMagick (identify) is required. Install with: sudo apt-get install imagemagick" >&2; exit 1; }

HAS_JPEGOPTIM=0
if command -v jpegoptim >/dev/null 2>&1; then
  HAS_JPEGOPTIM=1
else
  echo "Warning: jpegoptim not found. JPEG optimization step will be skipped." >&2
fi

HAS_OPTIPNG=0
if command -v optipng >/dev/null 2>&1; then
  HAS_OPTIPNG=1
else
  echo "Warning: optipng not found. PNG optimization step will be skipped." >&2
fi

HAS_CWEBP=0
if command -v cwebp >/dev/null 2>&1; then
  HAS_CWEBP=1
else
  echo "Warning: cwebp not found. Falling back to ImageMagick for WebP conversion." >&2
fi

mkdir -p "$OUTPUT_DIR"

to_lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

is_supported_source_ext() {
  local ext
  ext="$(to_lower "$1")"
  [[ "$ext" == "jpg" || "$ext" == "jpeg" || "$ext" == "png" || "$ext" == "webp" ]]
}

is_banner_like() {
  local name_lc
  name_lc="$(to_lower "$1")"
  [[ "$name_lc" == *"banner"* || "$name_lc" == *"hero"* || "$name_lc" == *"header"* ]]
}

detect_resize_width() {
  local input_file="$1"
  local filename="$2"

  if [[ "$input_file" == *"/members/"* ]]; then
    echo "$PROFILE_WIDTH"
  elif is_banner_like "$filename"; then
    echo "$BANNER_WIDTH"
  elif [[ "$filename" == *"icon"* || "$filename" == *"logo"* || "$input_file" == *"/icons/"* ]]; then
    echo "$ICON_WIDTH"
  else
    echo "$MAX_WIDTH"
  fi
}

create_webp() {
  local source_file="$1"
  local target_webp="$2"

  if [[ "$HAS_CWEBP" -eq 1 ]]; then
    cwebp -quiet -q "$WEBP_QUALITY" "$source_file" -o "$target_webp"
  else
    convert "$source_file" -quality "$WEBP_QUALITY" "$target_webp"
  fi
}

optimize_original_if_possible() {
  local file_path="$1"
  local ext="$2"

  case "$ext" in
    jpg|jpeg)
      if [[ "$HAS_JPEGOPTIM" -eq 1 ]]; then
        jpegoptim --max="$JPEG_MAX" "$file_path" >/dev/null
      fi
      ;;
    png)
      if [[ "$HAS_OPTIPNG" -eq 1 ]]; then
        optipng -o"$PNG_LEVEL" "$file_path" >/dev/null
      fi
      ;;
  esac
}

process_image() {
  local input_file="$1"
  input_file="${input_file#./}"

  if [[ ! -f "$input_file" ]]; then
    echo "Skipping missing file: $input_file" >&2
    return 0
  fi

  if [[ "$input_file" != "$IMAGE_DIR/"* ]]; then
    echo "Skipping file outside ${IMAGE_DIR}: $input_file" >&2
    return 0
  fi

  local rel_path dir_path filename extension ext_lc basename
  rel_path="${input_file#"$IMAGE_DIR/"}"
  dir_path="$(dirname "$rel_path")"
  filename="$(basename "$input_file")"
  extension="${filename##*.}"
  ext_lc="$(to_lower "$extension")"
  basename="${filename%.*}"

  if ! is_supported_source_ext "$ext_lc"; then
    echo "Skipping unsupported format: $rel_path"
    return 0
  fi

  local output_file webp_file
  if [[ "$dir_path" != "." ]]; then
    mkdir -p "$OUTPUT_DIR/$dir_path"
    output_file="$OUTPUT_DIR/$dir_path/$basename.$ext_lc"
    webp_file="$OUTPUT_DIR/$dir_path/$basename.webp"
  else
    output_file="$OUTPUT_DIR/$basename.$ext_lc"
    webp_file="$OUTPUT_DIR/$basename.webp"
  fi

  echo "Processing: $rel_path"

  local resize_width current_width
  resize_width="$(detect_resize_width "$input_file" "$filename")"
  current_width="$(identify -format "%w" "$input_file")"

  local tmp_file
  tmp_file="$(mktemp "/tmp/resize-images.XXXXXX.${ext_lc}")"

  if [[ "$current_width" -gt "$resize_width" ]]; then
    echo "  Resizing to ${resize_width}px width"
    convert "$input_file" -resize "${resize_width}x" -quality "$RESIZE_QUALITY" "$tmp_file"
  else
    echo "  Keeping original dimensions (${current_width}px wide)"
    cp "$input_file" "$tmp_file"
  fi

  optimize_original_if_possible "$tmp_file" "$ext_lc"

  cp "$tmp_file" "$output_file"

  echo "  Creating WebP version"
  create_webp "$tmp_file" "$webp_file"

  local original_bytes webp_bytes
  original_bytes="$(stat -c%s "$output_file")"
  webp_bytes="$(stat -c%s "$webp_file")"
  echo "  Done: ${basename}.${ext_lc}=${original_bytes} bytes, ${basename}.webp=${webp_bytes} bytes"
  echo

  rm -f "$tmp_file"

  if [[ "$ENABLE_MOBILE" -eq 1 ]] && is_banner_like "$filename"; then
    create_mobile_version "$input_file" "$dir_path" "$basename" "$ext_lc"
  fi
}

create_mobile_version() {
  local input_file="$1"
  local dir_path="$2"
  local basename="$3"
  local ext_lc="$4"

  local mobile_file mobile_webp
  if [[ "$dir_path" != "." ]]; then
    mkdir -p "$OUTPUT_DIR/$dir_path"
    mobile_file="$OUTPUT_DIR/$dir_path/$basename-mobile.$ext_lc"
    mobile_webp="$OUTPUT_DIR/$dir_path/$basename-mobile.webp"
  else
    mobile_file="$OUTPUT_DIR/$basename-mobile.$ext_lc"
    mobile_webp="$OUTPUT_DIR/$basename-mobile.webp"
  fi

  echo "  Creating mobile version (${MOBILE_WIDTH}px): ${basename}-mobile"
  convert "$input_file" -resize "${MOBILE_WIDTH}x" -quality "$MOBILE_QUALITY" "$mobile_file"
  optimize_original_if_possible "$mobile_file" "$ext_lc"
  create_webp "$mobile_file" "$mobile_webp"
  echo
}

apply_outputs() {
  echo "Applying optimized files back into ${IMAGE_DIR}..."

  local find_expr
  if [[ "$APPLY_ORIGINALS" -eq 1 ]]; then
    find_expr=(-type f)
  else
    find_expr=(-type f -iname '*.webp')
  fi

  while IFS= read -r file; do
    local dest_file dest_dir
    dest_file="${file/$OUTPUT_DIR/$IMAGE_DIR}"
    dest_dir="$(dirname "$dest_file")"
    mkdir -p "$dest_dir"
    cp "$file" "$dest_file"
    echo "  Applied: ${dest_file#"$IMAGE_DIR/"}"
  done < <(find "$OUTPUT_DIR" "${find_expr[@]}" -not -path '*/.*')
}

collect_files() {
  if [[ ${#FILES[@]} -gt 0 ]]; then
    printf '%s\n' "${FILES[@]}"
  else
    find "$IMAGE_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -not -path "$OUTPUT_DIR/*"
  fi
}

echo "Processing images..."
while IFS= read -r img; do
  [[ -z "$img" ]] && continue
  process_image "$img"
done < <(collect_files)

echo "All processing complete. Output directory: ${OUTPUT_DIR}"

if [[ "$APPLY_RESULTS" -eq 1 ]]; then
  apply_outputs
  echo "\nApplied optimized outputs to ${IMAGE_DIR}."
else
  echo "\nTo apply results back to source tree, rerun with --apply"
fi
