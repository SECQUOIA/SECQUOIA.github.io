# Exercise the validation command with isolated tool stand-ins: an upstream
# failure must survive log capture and produce a failing overall exit status.
require "fileutils"
require "open3"
require "tmpdir"

repo_root = File.expand_path(ARGV[0] || "..", __dir__)
script = File.join(repo_root, "validate.sh")
failures = []
cases = [
  ["healthy native checks", "native", {}, true],
  ["broken internal link", "native", {"PROOF_EXIT" => "17"}, false],
  ["failed Jekyll build", "native", {"BUILD_EXIT" => "23"}, false],
  ["missing generated index", "native", {"MISSING_INDEX" => "1"}, false],
  ["missing HTMLProofer", "native", {"MISSING_PROOFER" => "1"}, false],
  ["invalid YAML", "native", {"YAML_EXIT" => "1"}, false],
  ["non-UTF8 Markdown", "native", {"NON_UTF8" => "1"}, false],
  ["style warnings only", "native", {"STYLE_WARNINGS" => "1"}, true],
  ["missing build tools", "none", {}, false],
  ["Docker unavailable", "docker", {"DOCKER_UNAVAILABLE" => "1"}, false],
  ["Docker image build fails", "docker", {"DOCKER_BUILD_FAIL" => "1"}, false],
  ["healthy Docker checks", "docker", {}, true],
  ["Docker link failure", "docker", {"PROOF_EXIT" => "17"}, false],
  ["Docker YAML failure", "docker", {"YAML_EXIT" => "1"}, false]
]

cases.each do |name, mode, settings, expected_success|
  Dir.mktmpdir("site-validation-") do |dir|
    bin = File.join(dir, "bin")
    container_bin = File.join(dir, "container-bin")
    FileUtils.mkdir_p([bin, container_bin])
    # Do not let an installed Docker, Bundler or sudo escape the fixture.
    %w[bash cat find grep head tee file mkdir].each do |command|
      path = ENV.fetch("PATH").split(File::PATH_SEPARATOR)
                .map { |part| File.join(part, command) }.find { |candidate| File.executable?(candidate) && !File.directory?(candidate) }
      abort "Missing fixture prerequisite: #{command}" unless path
      FileUtils.ln_s(path, File.join(bin, command))
    end
    bundle = <<~'BASH'
      #!/bin/bash
      if [[ "$1 $2 $3" == "exec jekyll build" ]]; then
        if [[ "${BUILD_EXIT:-0}" != 0 ]]; then
          echo "Fixture Jekyll failure"
          exit "$BUILD_EXIT"
        fi
        mkdir -p _site
        if [[ "${MISSING_INDEX:-0}" != 1 ]]; then echo '<html></html>' > _site/index.html; fi
        exit 0
      fi
      if [[ "$1 $2 $3" == "exec htmlproofer --version" ]]; then
        exit "${MISSING_PROOFER:-0}"
      fi
      if [[ "$1 $2" == "exec htmlproofer" ]]; then
        if [[ "${PROOF_EXIT:-0}" != 0 ]]; then echo "Fixture broken internal link"; fi
        exit "${PROOF_EXIT:-0}"
      fi
      echo "Unexpected bundle call: $*" >&2
      exit 99
    BASH
    yaml = "#!/bin/bash\nexit \"${YAML_EXIT:-0}\"\n"
    tool_bin = mode == "native" ? bin : container_bin
    File.write(File.join(tool_bin, "bundle"), bundle)
    File.write(File.join(tool_bin, "yamllint"), yaml)
    FileUtils.chmod("+x", [File.join(tool_bin, "bundle"), File.join(tool_bin, "yamllint")])
    if mode == "docker"
      File.write(File.join(bin, "docker"), <<~'BASH')
        #!/bin/bash
        case "$1" in
          info) exit "${DOCKER_UNAVAILABLE:-0}" ;;
          image) exit "${DOCKER_BUILD_FAIL:-0}" ;;
          build) exit "${DOCKER_BUILD_FAIL:-0}" ;;
          run)
            until [[ "$1" == "secquoia-website" || $# == 0 ]]; do shift; done
            [[ $# != 0 ]] || exit 99
            shift
            export PATH="$CONTAINER_BIN:$PATH"
            exec "$@"
            ;;
          *) exit 99 ;;
        esac
      BASH
      FileUtils.chmod("+x", File.join(bin, "docker"))
    end
    File.write(File.join(dir, "test config.yml"), "key: value\n")
    if settings["STYLE_WARNINGS"]
      File.write(File.join(dir, "README.md"), "https://secquoia.github.io/  \n")
    end
    File.binwrite(File.join(dir, "README.md"), "\xE9" * 1000) if settings["NON_UTF8"]
    env = {"PATH" => bin, "CONTAINER_BIN" => container_bin}.merge(settings)
    output, status = Open3.capture2e(env, "bash", script, chdir: dir)
    errors = []
    errors << "expected success=#{expected_success}, got exit #{status.exitstatus}" unless status.success? == expected_success
    if !expected_success && output.include?("🎉 Validation complete!")
      errors << "reported completion after failure"
    end
    if settings["PROOF_EXIT"]
      errors << "lost the link failure log" unless output.include?("Fixture broken internal link")
      errors << "reported broken links as valid" if output.include?("✅ Internal links valid")
    end
    if settings["BUILD_EXIT"]
      errors << "lost the build failure log" unless output.include?("Fixture Jekyll failure")
      errors << "ran link checks after a failed build" if output.include?("🔗 Checking internal links")
    end
    if settings["STYLE_WARNINGS"]
      errors << "lost the whitespace warning" unless output.include?("Found trailing whitespace")
      errors << "warned about a valid lowercase hostname" if output.include?("⚠️  Found lowercase")
    end
    failures << "#{name}: #{errors.join('; ')}\n#{output}" unless errors.empty?
  end
end

abort failures.join("\n\n") unless failures.empty?
puts "#{cases.length} validation scenarios passed, including native and Docker failure propagation"
