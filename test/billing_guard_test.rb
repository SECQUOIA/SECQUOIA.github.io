require "fileutils"
require "json"
require "open3"
require "tmpdir"
require "yaml"

repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
billing_workflow = YAML.load_file(File.join(repo_root, ".github/workflows/billing-guard.yml"))
pages_workflow = YAML.load_file(File.join(repo_root, ".github/workflows/pages.yml"))

pages_if = pages_workflow.dig("jobs", "build-and-deploy", "if").to_s
unless pages_if.include?("github.event.workflow_run.event == 'push'") &&
       pages_if.include?("github.event.workflow_run.head_repository.full_name == github.repository")
  abort "pages.yml must restrict workflow_run checkout and cache access to same-repository push runs"
end

query_step = billing_workflow.dig("jobs", "check-billing", "steps").find { |s| s["id"] == "usage" }
abort "billing-guard.yml is missing the usage step" unless query_step
alert_step = billing_workflow.dig("jobs", "check-billing", "steps").find { |s| s["name"] == "Open or update alert issue" }
abort "billing-guard.yml is missing the alert issue step" unless alert_step
unless alert_step.dig("env", "GH_REPO") == "${{ github.repository }}"
  abort "billing-guard.yml alert step must set GH_REPO to ${{ github.repository }} so gh works without checkout"
end
env_defaults = billing_workflow.dig("jobs", "check-billing", "env")

scenarios = [
  [
    "private-repo threshold with public repos reporting grossAmount > 0 excluded",
    {
      usageItems: [
        {product: "Actions", sku: "Actions Linux", unitType: "minutes", quantity: 2050, grossAmount: 16.4, netAmount: 0.0, repositoryName: "Reproducible_state_task_network_problem"},
        {product: "Actions", sku: "Actions MacOS", unitType: "minutes", quantity: 20, grossAmount: 1.6, netAmount: 0.0, repositoryName: "QuantumChemistryViaIsing"},
        {product: "Actions", sku: "Actions Linux", unitType: "minutes", quantity: 5000, grossAmount: 30.0, netAmount: 0.0, repositoryName: "pyomo"},
        {product: "Actions", sku: "Actions Linux", unitType: "minutes", quantity: 500, grossAmount: 3.0, netAmount: 0.0, repositoryName: "SECQUOIA.github.io"}
      ]
    },
    %w[pyomo SECQUOIA.github.io],
    "billable",
    "2250"
  ],
  [
    "lowercase actions/Minutes below threshold with high public usage excluded",
    {
      usageItems: [
        {product: "actions", sku: "Actions Linux", unitType: "Minutes", quantity: 400, grossAmount: 3.2, netAmount: 0.0, repositoryName: "Reproducible_state_task_network_problem"},
        {product: "actions", sku: "Actions Windows", unitType: "Minutes", quantity: 50, grossAmount: 0.8, netAmount: 0.0, repositoryName: "QuantumChemistryViaIsing"},
        {product: "actions", sku: "Actions Linux", unitType: "Minutes", quantity: 9000, grossAmount: 54.0, netAmount: 0.0, repositoryName: "TenSolver.jl"}
      ]
    },
    %w[TenSolver.jl],
    "clean",
    "500"
  ]
]

scenarios.each do |name, payload, public_repos, expected_status, expected_equiv|
  Dir.mktmpdir("billing-guard-test-") do |dir|
    bin = File.join(dir, "bin")
    FileUtils.mkdir_p(bin)
    File.write(File.join(dir, "payload.json"), JSON.generate(payload))
    File.write(File.join(dir, "fixture_public_repos.txt"), public_repos.join("\n") + "\n")
    File.write(File.join(bin, "gh"), <<~'BASH')
      #!/bin/bash
      if [[ "$*" == *"repos?type=public"* ]]; then
        cat fixture_public_repos.txt
      else
        cat payload.json
      fi
    BASH
    FileUtils.chmod("+x", File.join(bin, "gh"))
    output_file = File.join(dir, "github_output.txt")
    File.write(output_file, "")
    env = env_defaults.merge(
      "PATH" => "#{bin}:#{ENV.fetch("PATH")}",
      "GITHUB_OUTPUT" => output_file
    )
    out, status = Open3.capture2e(env, "bash", "-c", query_step["run"], chdir: dir)
    abort "#{name} failed (#{status.exitstatus}):\n#{out}" unless status.success?
    outputs = File.read(output_file).lines.map(&:chomp).to_h { |line| line.split("=", 2) }
    unless outputs["status"] == expected_status && outputs["equiv_minutes"] == expected_equiv
      abort "#{name}: expected status=#{expected_status} equiv_minutes=#{expected_equiv}, got #{outputs.inspect}"
    end
  end
end

# Verify the alert step passes --repo explicitly and succeeds outside a git repo.
Dir.mktmpdir("billing-guard-alert-test-") do |dir|
  bin = File.join(dir, "bin")
  FileUtils.mkdir_p(bin)
  calls_log = File.join(dir, "gh_calls.log")
  File.write(File.join(bin, "gh"), <<~'BASH')
    #!/bin/bash
    ruby -rjson -e 'puts JSON.generate(ARGV)' -- "$@" >> "$CALLS_LOG"
    if [[ "$1 $2" == "issue list" ]]; then
      echo ""
    fi
  BASH
  FileUtils.chmod("+x", File.join(bin, "gh"))
  env = env_defaults.merge(
    "PATH" => "#{bin}:#{ENV.fetch("PATH")}",
    "CALLS_LOG" => calls_log,
    "GH_REPO" => "SECQUOIA/SECQUOIA.github.io",
    "GH_TOKEN" => "dummy",
    "TOTAL" => "69.33",
    "EQUIV_MINUTES" => "500",
    "YEAR" => "2026",
    "MONTH" => "11"
  )
  out, status = Open3.capture2e(env, "bash", "-c", alert_step["run"], chdir: dir)
  abort "alert step failed (#{status.exitstatus}):\n#{out}" unless status.success?
  calls = File.read(calls_log).lines.map { |line| JSON.parse(line) }
  unless calls.length == 2 && calls.all? { |argv| argv.each_cons(2).include?(["--repo", "SECQUOIA/SECQUOIA.github.io"]) }
    abort "alert step did not pass --repo to gh issue calls: #{calls.inspect}"
  end
end

puts "billing guard handles public/private Actions filtering, explicit --repo alerts, and pages.yml push trust guards"
