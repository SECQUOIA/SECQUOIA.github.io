# Regression test for scripts/check_webp_equivalents.sh.
# Proves the guard fails when a raster image has no .webp equivalent and
# passes once the .webp twin is added, so CI blocks new images that would
# break the client-side WebP swap in assets/js/image-loader.js.
require "tmpdir"
require "fileutils"

repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
script = File.join(repo_root, "scripts/check_webp_equivalents.sh")
abort "guard script not found: #{script}" unless File.file?(script)

def guard_passes?(script, dir)
  system("bash", script, dir, out: File::NULL, err: File::NULL)
end

Dir.mktmpdir do |dir|
  images = File.join(dir, "assets", "images")
  FileUtils.mkdir_p(images)
  File.binwrite(File.join(images, "sample.png"), "\x89PNG\r\n\x1a\n")

  # 1. A .png with no sibling .webp must make the guard fail.
  if guard_passes?(script, images)
    abort "Expected the guard to FAIL when sample.png has no sibling .webp, but it passed."
  end

  # 2. Adding the .webp twin must make the guard pass.
  File.binwrite(File.join(images, "sample.webp"), "RIFF\x00\x00\x00\x00WEBP")
  unless guard_passes?(script, images)
    abort "Expected the guard to PASS once sample.webp exists, but it failed."
  end

  # 3. A .gif is also a non-WebP raster format: no twin must fail the guard.
  File.binwrite(File.join(images, "animation.gif"), "GIF89a")
  if guard_passes?(script, images)
    abort "Expected the guard to FAIL when animation.gif has no sibling .webp, but it passed."
  end

  # 4. Adding the .gif's .webp twin must make the guard pass again.
  File.binwrite(File.join(images, "animation.webp"), "RIFF\x00\x00\x00\x00WEBP")
  unless guard_passes?(script, images)
    abort "Expected the guard to PASS once animation.webp exists, but it failed."
  end
end

puts "webp-equivalents guard fails on a missing twin and passes when the .webp is present"
