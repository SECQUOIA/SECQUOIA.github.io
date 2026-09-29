require "nokogiri"

site = File.expand_path(ARGV[0] || "../_site", __dir__)
page = Nokogiri::HTML(File.read(File.join(site, "index.html")))
competing_themes = page.css("link[href]").select do |link|
  link["href"].include?("/highlight.js/") && link["href"].end_with?(".css")
end
abort "Highlight.js must use the bundled theme without a competing CDN stylesheet" unless competing_themes.empty?

css = File.read(File.join(site, "assets/css/main.css"))
abort "The bundled syntax theme must be loaded" unless css.match?(/@import\s*["']highlight\.css["']/)

mask_rules = css.scan(/([^{}]+)\{([^{}]*)\}/).select do |_selector, declarations|
  declarations.match?(/(?:\A|;)\s*mask-image\s*:/)
end
abort "No icon masks found in the built stylesheet" if mask_rules.empty?
mask_rules.each do |selector, declarations|
  %w[image repeat position].each do |property|
    standard = declarations[/(?:\A|;)\s*mask-#{property}\s*:\s*([^;]+)(?:;|\z)/, 1]
    webkit = declarations[/(?:\A|;)\s*-webkit-mask-#{property}\s*:\s*([^;]+)(?:;|\z)/, 1]
    abort "Missing or mismatched WebKit mask-#{property} in #{selector.strip}" unless standard && standard == webkit
  end
end

puts "Bundled syntax theme and WebKit fallbacks for #{mask_rules.length} icon mask rules verified"
