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

bibtex_blocks = page.css("details.pub-bibtex pre code").map(&:text)
abort "Expected BibTeX blocks on 4-publications.html" if bibtex_blocks.empty?
seen_keys = {}
bibtex_types = Hash.new(0)
bibtex_blocks.each_with_index do |bib, idx|
  header = bib[/\A@([a-z]+)\{([^,\s]+),/, 0]
  abort "Malformed BibTeX header at index #{idx}: #{bib.lines.first.inspect}" unless header
  entry_type = Regexp.last_match(1)
  cite_key = Regexp.last_match(2)
  bibtex_types[entry_type] += 1
  abort "Non-ASCII or invalid BibTeX key #{cite_key.inspect}" unless cite_key.match?(/\A[a-z0-9]+\z/)
  abort "Duplicate BibTeX key #{cite_key.inspect}" if seen_keys.key?(cite_key)
  seen_keys[cite_key] = true

  # Ensure no unescaped TeX alignment/comment/parameter/subscript characters or non-NFC marks appear in non-URL lines
  abort "Non-NFC characters in BibTeX (#{cite_key})" unless bib == bib.unicode_normalize(:nfc)
  bib.each_line do |line|
    next if line.lstrip.start_with?("url =", "doi =")
    abort "Unescaped & in BibTeX (#{cite_key}): #{line.strip}" if line.match?(/(?<!\\)&/)
    abort "Unescaped % in BibTeX (#{cite_key}): #{line.strip}" if line.match?(/(?<!\\)%/)
    abort "Unescaped # in BibTeX (#{cite_key}): #{line.strip}" if line.match?(/(?<!\\)#/)
    abort "Unescaped _ in BibTeX (#{cite_key}): #{line.strip}" if line.match?(/(?<!\\)_/)
  end
end

# Verify trailing TeX special characters (& % # _) are preserved and escaped rather than trimmed
trailing_fixture = [
  {
    "Authors" => "Bernal Neira, David E_;",
    "Title" => "Yield 50%",
    "Publication" => "R&D &",
    "Pages" => "1–10#",
    "Year" => "2026",
    "Publisher" => "Press_1_",
    "Type" => "Book / Chapter",
    "DOI" => "10.1000/test_1"
  }
]
grouped_template = jekyll_site.liquid_renderer.file("publication-bibtex-fixture").parse('{% include publications style="apa" link=true group_by_year=true %}')
grouped_rendered = grouped_template.render!(
  {"site" => {"data" => {"citations" => trailing_fixture}}},
  registers: {site: jekyll_site}
)
fixture_bib = Nokogiri::HTML.fragment(grouped_rendered).at_css("details.pub-bibtex pre code")&.text.to_s
[
  'author = {Bernal Neira, David E\_}',
  'title = {Yield 50\%}',
  'booktitle = {R\&D \&}',
  'publisher = {Press\_1\_}',
  'pages = {1--10\#}',
  'doi = {10.1000/test_1}'
].each do |expected_field|
  abort "Expected #{expected_field.inspect} in trailing-character BibTeX fixture, got:\n#{fixture_bib}" unless fixture_bib.include?(expected_field)
end

%w[article inproceedings incollection proceedings phdthesis mastersthesis misc].each do |req_type|
  abort "Expected at least one @#{req_type} in BibTeX exports, got #{bibtex_types.inspect}" unless bibtex_types[req_type].positive?
end
abort "Expected B.Sc. Thesis type annotation in @mastersthesis export" unless bibtex_blocks.any? { |b| b.include?("@mastersthesis{") && b.include?("type = {B.Sc. Thesis}") && b.include?("school = {Universidad de los Andes}") }
abort "Expected @proceedings with editor field for edited proceedings" unless bibtex_blocks.any? { |b| b.start_with?("@proceedings{") && b.include?("editor = {") }
puts "Verified #{bibtex_blocks.length} unique, ASCII-keyed, TeX-escaped BibTeX blocks (#{bibtex_types.inspect})"
