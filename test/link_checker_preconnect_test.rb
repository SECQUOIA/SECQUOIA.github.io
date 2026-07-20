repo_root = ARGV[0] ? File.expand_path(ARGV[0]) : File.expand_path("..", __dir__)
workflow = File.read(File.join(repo_root, ".github/workflows/link-checker.yml"))
ignore_urls = workflow[/--ignore-urls\s+"([^"]+)"/, 1]
abort "weekly link checker has no --ignore-urls configuration" unless ignore_urls

patterns = ignore_urls.split(",").map do |entry|
  abort "invalid ignore pattern: #{entry.inspect}" unless entry.start_with?("/") && entry.end_with?("/")
  Regexp.new(entry[1...-1])
end

origin_urls = ["https://cdnjs.cloudflare.com", "https://cdnjs.cloudflare.com/"]
asset_url = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
ignored_origins = origin_urls.select { |url| patterns.any? { |pattern| pattern.match?(url) } }
asset_ignored = patterns.any? { |pattern| pattern.match?(asset_url) }

unless ignored_origins == origin_urls && !asset_ignored
  abort <<~MESSAGE
    Expected the weekly checker to ignore only the cdnjs preconnect origin.
    Observed ignored origins: #{ignored_origins.inspect}
    Observed asset ignored: #{asset_ignored}
    Configured patterns: #{ignore_urls}
  MESSAGE
end

puts "weekly checker ignores the cdnjs origin but still checks cdnjs assets"
