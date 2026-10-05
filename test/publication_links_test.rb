require "csv"
require "nokogiri"

root = File.expand_path("..", __dir__)
site = ARGV[0] ? File.expand_path(ARGV[0]) : File.join(root, "_site")
page = Nokogiri::HTML(File.read(File.join(site, "4-publications.html")))
links = page.css("#main ol a[href]")
abort "No publication links found" if links.empty?

# Check both CSV conventions against the rendered page, including the entry
# that previously sent readers to a blocked Scholar search.
examples = {
  "A Practical Framework for Assessing the Performance of Observable Estimation in Quantum Simulation" => "https://arxiv.org/abs/2504.09813",
  "QUBO. jl: A julia ecosystem for quadratic unconstrained binary optimization" => "https://arxiv.org/abs/2307.02577"
}
examples.each do |title, expected|
  link = links.find { |node| node.text == title }
  abort "Wrong link for #{title}: #{link&.[]('href')}" unless link && link["href"] == expected
end

arxiv_count = 0
scholar_count = 0
CSV.foreach(File.join(root, "_data/citations.csv"), headers: true) do |citation|
  matches = links.select { |node| node.text == citation["Title"] }
  abort "Missing publication: #{citation['Title']}" if matches.empty?
  id = [citation["Publication"], citation["Pages"]].compact.join(" ")[/arXiv:\s*(\d{4}\.\d{4,5})/, 1]
  if id
    abort "Expected direct arXiv link for #{citation['Title']}" unless matches.any? { |link| link["href"] == "https://arxiv.org/abs/#{id}" }
    arxiv_count += 1
  else
    abort "Missing Scholar fallback for #{citation['Title']}" unless matches.any? { |link| link["href"].start_with?("https://scholar.google.com/scholar?q=") }
    scholar_count += 1
  end
end
abort "Both direct links and fallbacks must be exercised" unless arxiv_count.positive? && scholar_count.positive?
puts "Verified #{arxiv_count} direct arXiv links and #{scholar_count} Scholar fallbacks"
