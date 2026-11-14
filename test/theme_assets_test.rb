require "nokogiri"

site = File.expand_path(ARGV[0] || "../_site", __dir__)
page = Nokogiri::HTML(File.read(File.join(site, "index.html")))
competing_themes = page.css("link[href]").select do |link|
  link["href"].include?("/highlight.js/") && link["href"].end_with?(".css")
end
abort "Highlight.js must use the bundled theme without a competing CDN stylesheet" unless competing_themes.empty?

cdn_fa = page.css("link[href]").select { |link| link["href"].include?("font-awesome") || link["href"].include?("cdnjs.cloudflare.com") }
abort "Font Awesome must be self-hosted without a CDN stylesheet or preconnect: #{cdn_fa.map(&:to_html)}" unless cdn_fa.empty?
local_fa = page.at_css("link[rel='stylesheet'][href$='/assets/css/fontawesome-all.min.css']")
abort "Missing self-hosted /assets/css/fontawesome-all.min.css link" unless local_fa
%w[fa-brands-400.woff2 fa-regular-400.woff2 fa-solid-900.woff2].each do |font_file|
  abort "Missing built webfont #{font_file}" unless File.file?(File.join(site, "assets/webfonts", font_file))
end

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
