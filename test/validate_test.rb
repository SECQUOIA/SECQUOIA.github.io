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
  ["missing yamllint", "native", {"MISSING_YAMLLINT" => "1"}, false],
  ["non-UTF8 Markdown", "native", {"NON_UTF8" => "1"}, false],
  ["ignored native files", "native", {"IGNORED_FILES" => "1"}, true],
  ["style warnings only", "native", {"STYLE_WARNINGS" => "1"}, true],
  ["missing build tools", "none", {}, false],
  ["uninstalled native bundle without Docker", "native", {"BUNDLE_CHECK_EXIT" => "1"}, false],
  ["uninstalled native bundle falls back to Docker", "both", {"BUNDLE_CHECK_EXIT" => "1"}, true],
  ["Docker unavailable", "docker", {"DOCKER_UNAVAILABLE" => "1"}, false],
  ["Docker image build fails", "docker", {"DOCKER_BUILD_FAIL" => "1"}, false],
  ["healthy Docker checks", "docker", {}, true],
  ["Docker hashed image rebuild when Gemfile changes", "docker", {"WITH_GEMFILE_HASH" => "1"}, true],
  ["Docker link failure", "docker", {"PROOF_EXIT" => "17"}, false],
  ["Docker YAML failure", "docker", {"YAML_EXIT" => "1"}, false],
  ["ignored Docker files", "docker", {"IGNORED_FILES" => "1"}, true]
]

cases.each do |name, mode, settings, expected_success|
  Dir.mktmpdir("site-validation-") do |dir|
    bin = File.join(dir, "bin")
    container_bin = File.join(dir, "container-bin")
    FileUtils.mkdir_p([bin, container_bin])
    # Do not let an installed Docker, Bundler or sudo escape the fixture.
    %w[bash cat find grep head tee file mkdir id sha256sum].each do |command|
      path = ENV.fetch("PATH").split(File::PATH_SEPARATOR)
                .map { |part| File.join(part, command) }.find { |candidate| File.executable?(candidate) && !File.directory?(candidate) }
      abort "Missing fixture prerequisite: #{command}" unless path
      FileUtils.ln_s(path, File.join(bin, command))
    end
    bundle = <<~'BASH'
      #!/bin/bash
      if [[ "$1" == "check" ]]; then
        exit "${BUNDLE_CHECK_EXIT:-0}"
      fi
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
    yaml = <<~'BASH'
      #!/bin/bash
      [[ "$*" == *ignored.yml* ]] && exit 99
      exit "${YAML_EXIT:-0}"
    BASH
    if mode == "native"
      File.write(File.join(bin, "bundle"), bundle)
      File.write(File.join(bin, "yamllint"), yaml)
      FileUtils.chmod("+x", [File.join(bin, "bundle"), File.join(bin, "yamllint")])
      FileUtils.rm(File.join(bin, "yamllint")) if settings["MISSING_YAMLLINT"]
    elsif mode == "both"
      host_bundle = <<~'BASH'
        #!/bin/bash
        if [[ "$1" == "check" ]]; then
          exit "${BUNDLE_CHECK_EXIT:-1}"
        fi
        echo "Host bundle should not run when bundle check fails" >&2
        exit 98
      BASH
      File.write(File.join(bin, "bundle"), host_bundle)
      FileUtils.chmod("+x", File.join(bin, "bundle"))
      File.write(File.join(container_bin, "bundle"), bundle)
      File.write(File.join(container_bin, "yamllint"), yaml)
      FileUtils.chmod("+x", [File.join(container_bin, "bundle"), File.join(container_bin, "yamllint")])
    else
      File.write(File.join(container_bin, "bundle"), bundle)
      File.write(File.join(container_bin, "yamllint"), yaml)
      FileUtils.chmod("+x", [File.join(container_bin, "bundle"), File.join(container_bin, "yamllint")])
      FileUtils.rm(File.join(container_bin, "yamllint")) if settings["MISSING_YAMLLINT"]
    end

    if mode == "docker" || mode == "both"
      File.write(File.join(bin, "docker"), <<~'BASH')
        #!/bin/bash
        case "$1" in
          info) exit "${DOCKER_UNAVAILABLE:-0}" ;;
          image)
            if [[ "${WITH_GEMFILE_HASH:-0}" == "1" ]]; then
              exit 1
            fi
            exit "${DOCKER_BUILD_FAIL:-0}"
            ;;
          build)
            echo "MOCK_DOCKER_BUILD:$*" >> "$DOCKER_LOG"
            exit "${DOCKER_BUILD_FAIL:-0}"
            ;;
          run)
            echo "MOCK_DOCKER_RUN:$*" >> "$DOCKER_LOG"
            until [[ "$1" == secquoia-website* || $# == 0 ]]; do shift; done
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

    if settings["WITH_GEMFILE_HASH"]
      File.write(File.join(dir, "Dockerfile"), "FROM ruby:3.2\n")
      File.write(File.join(dir, "Gemfile"), "source 'https://rubygems.org'\n")
      File.write(File.join(dir, "Gemfile.lock"), "GEM\n")
    end

    File.write(File.join(dir, "test config.yml"), "key: value\n")
    if settings["STYLE_WARNINGS"]
      File.write(File.join(dir, "README.md"), "https://secquoia.github.io/  \n")
    end
    File.binwrite(File.join(dir, "README.md"), "\xE9" * 1000) if settings["NON_UTF8"]
    if settings["IGNORED_FILES"]
      %w[vendor node_modules .git _site _sources].each do |ignored|
        FileUtils.mkdir_p(File.join(dir, ignored))
        File.binwrite(File.join(dir, ignored, "ignored.md"), "\xE9" * 1000 + "  \n")
        File.write(File.join(dir, ignored, "ignored.yml"), "invalid: [\n")
      end
    end
    docker_log = File.join(dir, "docker.log")
    env = {"PATH" => bin, "CONTAINER_BIN" => container_bin, "DOCKER_LOG" => docker_log}.merge(settings)
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
      errors << "warned about a valid lowercase hostname" if output.include?("Found lowercase")
    end
    if settings["IGNORED_FILES"]
      errors << "checked ignored YAML" if output.include?("ignored.yml")
      errors << "checked ignored whitespace" if output.include?("Found trailing whitespace")
    end
    if settings["DOCKER_UNAVAILABLE"]
      errors << "missing Docker recovery guidance" unless output.include?("daemon") && output.include?("docker group")
    end
    if (mode == "docker" || mode == "both") && expected_success && File.exist?(docker_log)
      log_text = File.read(docker_log)
      errors << "docker run missing --user flag" unless log_text.include?("--user ")
      if settings["WITH_GEMFILE_HASH"]
        errors << "docker build did not use hashed tag" unless log_text.match?(/MOCK_DOCKER_BUILD:.*secquoia-website:[0-9a-f]{12}/)
      end
    end
    failures << "#{name}: #{errors.join('; ')}\n#{output}" unless errors.empty?
  end
end

abort failures.join("\n\n") unless failures.empty?
puts "#{cases.length} validation scenarios passed, including native and Docker failure propagation"
