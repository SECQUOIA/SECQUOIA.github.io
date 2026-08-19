# Regression test for scripts/check_referenced_images.sh.
# The guard once passed vacuously: `grep ... || true | sed | while` parsed as
# `grep || (true | sed | while)`, so the extraction pipeline was skipped and no
# non-WebP reference was ever flagged. This test pins the repaired behavior so
# that precedence bug cannot silently return: every non-WebP <img> reference
# must fail and a WebP reference must pass, including when a WebP twin coexists.
require "tmpdir"
require "fileutils"

repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
script = File.join(repo_root, "scripts/check_referenced_images.sh")
abort "guard script not found: #{script}" unless File.file?(script)

def guard_passes?(script, site_dir)
  system("bash", script, site_dir, out: File::NULL, err: File::NULL)
end

def with_site(html)
  Dir.mktmpdir do |dir|
    site = File.join(dir, "_site")
    FileUtils.mkdir_p(site)
    File.write(File.join(site, "index.html"), html)
    yield site
  end
end

# Every non-WebP raster reference under assets/images must fail the guard.
%w[png jpg jpeg gif].each do |ext|
  with_site(%(<img src="/assets/images/posts/test.#{ext}" alt="x" />)) do |site|
    if guard_passes?(script, site)
      abort "Expected the guard to FAIL for a .#{ext} reference, but it passed."
    end
  end
end

# The precedence bug made *all* references pass; guard against its return even
# when the referenced PNG also has a WebP twin sitting beside it.
with_site(%(<img src="/assets/images/posts/test.png" alt="x" />\n) +
          %(<img src="/assets/images/posts/test.webp" alt="y" />)) do |site|
  if guard_passes?(script, site)
    abort "Expected the guard to FAIL when a .png is referenced alongside a .webp, but it passed."
  end
end

# A WebP-only reference must pass.
with_site(%(<img src="/assets/images/posts/test.webp" alt="x" />)) do |site|
  unless guard_passes?(script, site)
    abort "Expected the guard to PASS for a .webp reference, but it failed."
  end
end

puts "referenced-images guard fails on png/jpg/jpeg/gif references and passes on webp"
