# Regression test for scripts/check_repo_hygiene.sh.
# Proves the guard fails on a working file tracked in the repo root and on a
# tracked file above the size limit, and passes for a clean tree, so CI blocks
# stray slide sources or oversized PDFs before they reach the published site.
require "tmpdir"
require "fileutils"

repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
script = File.join(repo_root, "scripts/check_repo_hygiene.sh")
abort "guard script not found: #{script}" unless File.file?(script)

def git(dir, *args)
  system("git", "-C", dir, *args, out: File::NULL, err: File::NULL) or abort "git #{args.join(' ')} failed"
end

def guard_passes?(script, dir, max_mb)
  system("bash", script, dir, max_mb.to_s, out: File::NULL, err: File::NULL)
end

Dir.mktmpdir do |dir|
  git(dir, "init", "-q")
  FileUtils.mkdir_p(File.join(dir, "assets", "pdf"))
  File.write(File.join(dir, "index.md"), "# hi\n")
  File.binwrite(File.join(dir, "assets", "pdf", "deck.pdf"), "%PDF-1.7\n")
  git(dir, "add", "-A")

  # 1. A clean tree (PDF under assets/pdf/, small files) must pass.
  unless guard_passes?(script, dir, 1)
    abort "Expected the guard to PASS on a clean tree, but it failed."
  end

  # 2. A slide source tracked in the repo root must fail.
  File.binwrite(File.join(dir, "meeting.pptx"), "PK")
  git(dir, "add", "meeting.pptx")
  if guard_passes?(script, dir, 1)
    abort "Expected the guard to FAIL on a tracked root .pptx, but it passed."
  end
  git(dir, "rm", "-q", "--cached", "meeting.pptx")
  File.delete(File.join(dir, "meeting.pptx"))

  # 3. A PDF tracked in the repo root (instead of assets/pdf/) must fail.
  File.binwrite(File.join(dir, "Talk.pdf"), "%PDF-1.7\n")
  git(dir, "add", "Talk.pdf")
  if guard_passes?(script, dir, 1)
    abort "Expected the guard to FAIL on a tracked root .pdf, but it passed."
  end
  git(dir, "rm", "-q", "--cached", "Talk.pdf")
  File.delete(File.join(dir, "Talk.pdf"))

  # 4. A tracked file above the limit must fail, even in the right folder.
  File.binwrite(File.join(dir, "assets", "pdf", "big.pdf"), "0" * (1024 * 1024 + 1))
  git(dir, "add", "assets/pdf/big.pdf")
  if guard_passes?(script, dir, 1)
    abort "Expected the guard to FAIL on a tracked file above 1 MB, but it passed."
  end

  # 5. Raising the limit must make it pass again.
  unless guard_passes?(script, dir, 2)
    abort "Expected the guard to PASS with a 2 MB limit, but it failed."
  end
end

puts "repo-hygiene guard fails on stray root files and oversized tracked files, passes on a clean tree"
