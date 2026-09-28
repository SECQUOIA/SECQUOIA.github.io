# Regression test for scripts/compress_pdf.sh.
# Ghostscript opens its output before it finishes reading the input, so passing
# the same file as INPUT and OUTPUT (directly or through a symlink) used to
# replace the source with a blank one-page PDF while exiting 0. This proves the
# script rejects such aliases without touching the source bytes, and that a
# distinct output path still produces a compressed copy when Ghostscript is
# available.
require "tmpdir"
require "fileutils"
require "open3"
require "digest"

repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
script = File.join(repo_root, "scripts/compress_pdf.sh")
abort "script not found: #{script}" unless File.file?(script)

# Minimal single-page PDF that Ghostscript accepts.
MINIMAL_PDF = <<~PDF
  %PDF-1.4
  1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
  2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj
  3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 200 200] >> endobj
  trailer << /Root 1 0 R >>
PDF

def run(script, *args)
  _out, err, status = Open3.capture3("bash", script, *args)
  [status.exitstatus, err]
end

Dir.mktmpdir do |dir|
  input = File.join(dir, "deck.pdf")
  File.write(input, MINIMAL_PDF)
  original = Digest::SHA256.file(input).hexdigest

  # 1. Same path for input and output must be rejected, source untouched.
  code, err = run(script, input, "/ebook", input)
  abort "Expected rejection when OUTPUT == INPUT, got exit #{code}" if code == 0
  abort "Expected the error to name the alias, got: #{err}" unless err.include?("same file")
  abort "Source bytes changed on rejected same-path run" unless Digest::SHA256.file(input).hexdigest == original

  # 2. A symlink to the input must be rejected too, source untouched.
  link = File.join(dir, "deck-link.pdf")
  File.symlink(input, link)
  code, err = run(script, input, "/ebook", link)
  abort "Expected rejection when OUTPUT is a symlink to INPUT, got exit #{code}" if code == 0
  abort "Expected the error to name the alias, got: #{err}" unless err.include?("same file")
  abort "Source bytes changed on rejected symlink run" unless Digest::SHA256.file(input).hexdigest == original

  # 3. A missing input must be rejected before anything is written.
  code, _err = run(script, File.join(dir, "missing.pdf"), "/ebook", File.join(dir, "out.pdf"))
  abort "Expected rejection for a missing input, got exit #{code}" if code == 0
  abort "Output was created for a missing input" if File.exist?(File.join(dir, "out.pdf"))

  # 4. With a distinct output, the source is preserved and the output exists.
  if system("command -v gs >/dev/null 2>&1")
    output = File.join(dir, "deck-compressed.pdf")
    code, err = run(script, input, "/ebook", output)
    abort "Expected success with a distinct output, got exit #{code}: #{err}" unless code == 0
    abort "Output PDF was not written" unless File.file?(output) && File.read(output, 5) == "%PDF-"
    abort "Source bytes changed on a successful run" unless Digest::SHA256.file(input).hexdigest == original
    puts "compress_pdf guard rejects same-file and symlink outputs, preserves the source, and writes a distinct output"
  else
    puts "compress_pdf guard rejects same-file and symlink outputs and preserves the source (Ghostscript absent; distinct-output run skipped)"
  end
end
