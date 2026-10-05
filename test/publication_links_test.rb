require "csv"
require "jekyll"
require "nokogiri"

root = File.expand_path("..", __dir__)
site = ARGV[0] ? File.expand_path(ARGV[0]) : File.join(root, "_site")
page = Nokogiri::HTML(File.read(File.join(site, "4-publications.html")))
links = page.css("#main ol a[href]")
abort "No publication links found" if links.empty?

# Render the real include with edge cases independently of the current CSV.
examples = [
  ["Publication ID", "arXiv preprint arXiv:2504.09813", "", "https://arxiv.org/abs/2504.09813"],
  ["Version and subject", "arXiv:2504.09813v2 [math.OC]", "", "https://arxiv.org/abs/2504.09813v2"],
  ["Pages ID", "arXiv e-prints", "arXiv:2307.02577", "https://arxiv.org/abs/2307.02577"],
  ["Pages with another venue", "APS Meeting Abstracts", "arXiv:2307.02577v3 [quant-ph]", "https://arxiv.org/abs/2307.02577v3"],
  ["Legacy ID", "arXiv:hep-th/9901001", "", "https://arxiv.org/abs/hep-th/9901001"],
  ["Fallback & title", "Journal", "1-12", "https://scholar.google.com/scholar?q=Fallback+%26+title"]
]
citations = examples.map do |title, publication, pages, _expected|
  {"Authors" => "Example, A.;", "Title" => title, "Publication" => publication, "Pages" => pages, "Year" => "2026"}
end
jekyll_site = Jekyll::Site.new(Jekyll.configuration("source" => root, "quiet" => true))
template = jekyll_site.liquid_renderer.file("publication-link-fixture").parse('{% include publications style="apa" link=true %}')
rendered = template.render!(
  {"site" => {"data" => {"citations" => citations}}},
  registers: {site: jekyll_site}
)
fixture_links = Nokogiri::HTML.fragment(rendered).css("a[href]")
errors = []
examples.each do |title, _publication, _pages, expected|
  link = fixture_links.find { |node| node.text == title }
  errors << "Wrong link for #{title}: #{link&.[]('href').inspect}; expected #{expected}" unless link && link["href"] == expected
end
abort errors.join("\n") unless errors.empty?
puts "Verified #{examples.length} publication rendering scenarios"

arxiv_count = 0
scholar_count = 0
CSV.foreach(File.join(root, "_data/citations.csv"), headers: true) do |citation|
  matches = links.select { |node| node.text == citation["Title"] }
  abort "Missing publication: #{citation['Title']}" if matches.empty?
  id = [citation["Publication"], citation["Pages"]].compact.join(" ")[/arXiv:\s*(\S+)/, 1]
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
