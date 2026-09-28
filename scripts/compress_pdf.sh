#!/usr/bin/env bash
# Compress a PDF (typically a PowerPoint export) before committing it under
# assets/pdf/. Uses Ghostscript's /ebook profile (150 dpi images), which keeps
# slides sharp on screen while roughly halving the size, and preserves link
# annotations and fonts. Pass /printer as the second argument for 300 dpi.
# Usage: scripts/compress_pdf.sh INPUT.pdf [PROFILE] [OUTPUT.pdf]
#   PROFILE defaults to /ebook; OUTPUT defaults to INPUT with a -compressed suffix.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 INPUT.pdf [/ebook|/printer] [OUTPUT.pdf]" >&2
  exit 1
fi

INPUT="$1"
PROFILE="${2:-/ebook}"
OUTPUT="${3:-${INPUT%.pdf}-compressed.pdf}"

if [[ ! -f "$INPUT" ]]; then
  echo "Input '$INPUT' is not a file." >&2
  exit 1
fi
# Ghostscript opens the output for writing before it finishes reading the
# input, so pointing both at the same file (directly or through a symlink or
# hard link) truncates the source to a blank page and still exits 0.
if [[ "$INPUT" -ef "$OUTPUT" ]]; then
  echo "Output '$OUTPUT' is the same file as input '$INPUT'; choose a different output path." >&2
  exit 1
fi
if ! command -v gs >/dev/null 2>&1; then
  echo "Ghostscript (gs) is required. Install it with 'sudo apt-get install ghostscript' or 'brew install ghostscript'." >&2
  exit 1
fi

gs -q -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
  -dPDFSETTINGS="$PROFILE" -dDetectDuplicateImages=true \
  -sOutputFile="$OUTPUT" "$INPUT"

before=$(wc -c < "$INPUT")
after=$(wc -c < "$OUTPUT")
printf '%s: %d MB -> %d MB (%s)\n' "$OUTPUT" $(( before / 1024 / 1024 )) $(( after / 1024 / 1024 )) "$PROFILE"
