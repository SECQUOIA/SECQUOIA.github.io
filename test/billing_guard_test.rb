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
env_defaults = billing_workflow.dig("jobs", "check-billing", "env")

scenarios = [
  [
    "zero-net-charge threshold with documented Actions/minutes casing",
    {
      usageItems: [
        {product: "Actions", sku: "Actions Linux", unitType: "minutes", quantity: 1300, grossAmount: 10.4, netAmount: 0.0, repositoryName: "Black-Box-for-GDP"},
        {product: "Actions", sku: "Actions MacOS", unitType: "minutes", quantity: 20, grossAmount: 1.6, netAmount: 0.0, repositoryName: "QuantumChemistryViaIsing"},
        {product: "Actions", sku: "Actions Linux", unitType: "minutes", quantity: 5000, grossAmount: 0.0, netAmount: 0.0, repositoryName: "SECQUOIA.github.io"}
      ]
    },
    "billable",
    "1500"
  ],
  [
    "lowercase actions/Minutes below threshold with zero net charge",
    {
      usageItems: [
        {product: "actions", sku: "Actions Linux", unitType: "Minutes", quantity: 400, grossAmount: 3.2, netAmount: 0.0, repositoryName: "Reproducible_state_task_network_problem"},
        {product: "actions", sku: "Actions Windows", unitType: "Minutes", quantity: 50, grossAmount: 0.8, netAmount: 0.0, repositoryName: "QuantumChemistryViaIsing"}
      ]
    },
    "clean",
    "500"
  ]
]

scenarios.each do |name, payload, expected_status, expected_equiv|
  Dir.mktmpdir("billing-guard-test-") do |dir|
    bin = File.join(dir, "bin")
    FileUtils.mkdir_p(bin)
    File.write(File.join(dir, "payload.json"), JSON.generate(payload))
    File.write(File.join(bin, "gh"), <<~'BASH')
      #!/bin/bash
      cat payload.json
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

puts "billing guard handles documented and lowercase Actions usage fixtures and pages.yml enforces push trust guards"
