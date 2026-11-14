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
  ["DOI priority", "Journal", "1-10", "2026", "10.1000/xyz123", "https://example.org/alt", "https://doi.org/10.1000/xyz123"],
  ["Direct URL priority", "Thesis", "", "2021", "", "https://kilthub.cmu.edu/articles/thesis/123", "https://kilthub.cmu.edu/articles/thesis/123"],
  ["Publication ID", "arXiv preprint arXiv:2504.09813", "", "2026", "", "", "https://arxiv.org/abs/2504.09813"],
  ["Version and subject", "arXiv:2504.09813v2 [math.OC]", "", "2026", "", "", "https://arxiv.org/abs/2504.09813v2"],
  ["Pages ID", "arXiv e-prints", "arXiv:2307.02577", "2026", "", "", "https://arxiv.org/abs/2307.02577"],
  ["Pages with another venue", "APS Meeting Abstracts", "arXiv:2307.02577v3 [quant-ph]", "2026", "", "", "https://arxiv.org/abs/2307.02577v3"],
  ["Legacy ID", "arXiv:hep-th/9901001", "", "2026", "", "", "https://arxiv.org/abs/hep-th/9901001"],
  ["Fallback & title", "Journal", "1-12", "2026", "", "", "https://scholar.google.com/scholar?q=Fallback+%26+title"],
  ["Missing venue and year", "", "", "", "", "", "https://scholar.google.com/scholar?q=Missing+venue+and+year"]
]
citations = examples.map do |title, publication, pages, year, doi, url, _expected|
  {
    "Authors" => "Bernal Neira, David E; et al.;",
    "Title" => title,
    "Publication" => publication,
    "Pages" => pages,
    "Year" => year,
    "DOI" => doi,
    "URL" => url
  }
end
jekyll_site = Jekyll::Site.new(Jekyll.configuration("source" => root, "quiet" => true))
template = jekyll_site.liquid_renderer.file("publication-link-fixture").parse('{% include publications style="apa" link=true %}')
rendered = template.render!(
  {"site" => {"data" => {"citations" => citations}}},
  registers: {site: jekyll_site}
)
abort "Malformed empty delimiters rendered: #{rendered}" if rendered.include?("()") || rendered.include?("<em></em>")
abort "PI surname misparsed in fixture: #{rendered}" unless rendered.include?("Bernal Neira, D., et al.")

fixture_links = Nokogiri::HTML.fragment(rendered).css("a[href]")
errors = []
examples.each do |title, _publication, _pages, _year, _doi, _url, expected|
  link = fixture_links.find { |node| node.text == title }
  errors << "Wrong link for #{title}: #{link&.[]('href').inspect}; expected #{expected}" unless link && link["href"] == expected
end
abort errors.join("\n") unless errors.empty?
puts "Verified #{examples.length} publication rendering scenarios"

direct_count = 0
scholar_count = 0
CSV.foreach(File.join(root, "_data/citations.csv"), headers: true) do |citation|
  abort "Empty Year for #{citation['Title']}" if citation["Year"].to_s.strip.empty?
  abort "Empty Publication for #{citation['Title']}" if citation["Publication"].to_s.strip.empty?
  matches = links.select { |node| node.text == citation["Title"] }
  abort "Missing publication: #{citation['Title']}" if matches.empty?

  doi = citation["DOI"].to_s.strip
  direct_url = citation["URL"].to_s.strip
  arxiv_id = [citation["Publication"], citation["Pages"], direct_url].compact.join(" ")[/(?:arXiv:\s*|arxiv\.org\/abs\/)(\S+)/, 1]

  if !doi.empty?
    abort "Expected direct DOI link for #{citation['Title']}" unless matches.any? { |link| link["href"] == "https://doi.org/#{doi}" }
    direct_count += 1
  elsif !direct_url.empty?
    abort "Expected direct URL link for #{citation['Title']}" unless matches.any? { |link| link["href"] == direct_url }
    direct_count += 1
  elsif arxiv_id
    abort "Expected direct arXiv link for #{citation['Title']}" unless matches.any? { |link| link["href"] == "https://arxiv.org/abs/#{arxiv_id}" }
    direct_count += 1
  else
    abort "Missing Scholar fallback for #{citation['Title']}" unless matches.any? { |link| link["href"].start_with?("https://scholar.google.com/scholar?q=") }
    scholar_count += 1
  end
end
abort "Both direct links and fallbacks must be exercised" unless direct_count.positive? && scholar_count.positive?
puts "Verified #{direct_count} direct DOI/URL/arXiv links and #{scholar_count} Scholar fallbacks"
