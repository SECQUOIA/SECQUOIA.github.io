# Check the generated pages: social crawlers must see the article cover,
# while pages without an override retain the site's group photograph.
require "nokogiri"
require "uri"

site_dir = File.expand_path(ARGV.fetch(0, "_site"))

def meta(document, property)
  tags = document.css(%(meta[property="#{property}"]))
  abort "Expected one #{property} tag, found #{tags.length}" unless tags.length == 1
  tags.first["content"]
end

%w[en es ru].each do |language|
  prefix = language == "en" ? "" : "#{language}/"
  path = File.join(site_dir, prefix, "ai-agents-can-already-do-research/index.html")
  document = Nokogiri::HTML(File.read(path))
  image = meta(document, "og:image")
  uri = URI(image)
  suffix = "/assets/images/ai-agents-research/cover-#{language}.png"
  unless uri.is_a?(URI::HTTPS) && uri.host && uri.path.end_with?(suffix)
    abort "#{language}: expected an absolute cover URL ending in #{suffix}, got #{image}"
  end
  abort "#{language}: Twitter image differs" unless meta(document, "twitter:image") == image
  alt = meta(document, "og:image:alt")
  abort "#{language}: missing translated image description" if alt.to_s.strip.empty?
  abort "#{language}: Twitter description differs" unless meta(document, "twitter:image:alt") == alt

  png = File.binread(File.join(site_dir, suffix.delete_prefix("/")))
  abort "#{language}: preview is not a PNG" unless png.start_with?("\x89PNG\r\n\x1a\n".b)
  width, height = png.byteslice(16, 8).unpack("NN")
  abort "#{language}: preview must be 1200 × 630" unless [width, height] == [1200, 630]
  abort "#{language}: preview exceeds LinkedIn's 5 MB limit" unless png.bytesize < 5_000_000
  unless meta(document, "og:image:width") == width.to_s && meta(document, "og:image:height") == height.to_s
    abort "#{language}: image dimension metadata differs from the asset"
  end
  twin = File.join(site_dir, suffix.delete_prefix("/").sub(/\.png$/, ".webp"))
  abort "#{language}: missing WebP equivalent" unless File.file?(twin)

  cover = document.at_css(".article-cover img")
  unless cover && URI(cover["src"]).path.end_with?(suffix.sub(/\.png$/, ".webp")) && cover["alt"] == alt
    abort "#{language}: article does not embed its own localized cover"
  end
  unless URI(cover.parent["href"]).path.end_with?(suffix) && cover["width"] == width.to_s && cover["height"] == height.to_s
    abort "#{language}: full-size cover link or dimensions differ"
  end

  # Figure 1 is separate from the blog cover and contains the complete procedure.
  figure = document.at_css("#research-setup")
  inline = figure&.at_css("a.research-diagram img")
  method_suffix = "/assets/images/ai-agents-research/methodology-#{language}.png"
  unless inline && URI(inline["src"]).path.end_with?(method_suffix.sub(/\.png$/, ".webp"))
    abort "#{language}: article does not embed its own methodology figure"
  end
  unless URI(inline.parent["href"]).path.end_with?(method_suffix) && inline["width"] == "1200" && inline["height"] == "630"
    abort "#{language}: full-size methodology link or dimensions differ"
  end
  method_path = File.join(site_dir, method_suffix.delete_prefix("/"))
  method_png = File.binread(method_path)
  unless method_png.start_with?("\x89PNG\r\n\x1a\n".b) && method_png.byteslice(16, 8).unpack("NN") == [1200, 630]
    abort "#{language}: methodology PNG must be 1200 × 630"
  end
  twin = method_path.sub(/\.png$/, ".webp")
  abort "#{language}: missing methodology WebP" unless File.file?(twin)

  # Every instruction must be inside the methodology image itself, not only in adjacent HTML.
  # Compare the editable export with the article to catch omitted or invented copy.
  svg_path = twin.sub(/\.webp$/, ".svg")
  abort "#{language}: missing editable methodology source" unless File.file?(svg_path)
  svg = Nokogiri::XML(File.read(svg_path)) { |config| config.strict.nonet }
  svg.remove_namespaces!
  steps = figure.css(".research-steps > li")
  exported_steps = svg.css("g.step")
  abort "#{language}: expected three article and methodology steps" unless steps.length == 3 && exported_steps.length == 3
  expected_alt = steps.map { |step| step.at_css("h3").text.split.join(" ") }.join(" ")
  unless inline["alt"] == expected_alt
    abort "#{language}: methodology alt text differs from the current step headings"
  end
  steps.zip(exported_steps).each_with_index do |(original, exported), index|
    expected = original.text.split.join(" ")
    actual = exported.css("text").map(&:text).join(" ").split.join(" ")
    abort "#{language}: methodology step #{index + 1} differs from the article" unless actual == expected
  end
end

home = Nokogiri::HTML(File.read(File.join(site_dir, "index.html")))
%w[og:image twitter:image].each do |property|
  image = URI(meta(home, property))
  unless image.is_a?(URI::HTTPS) && image.host && image.path.end_with?("/assets/images/group2024.jpg")
    abort "Home page lost its default group image: #{property}"
  end
end

puts "Social previews use localized covers; methodology figures preserve the complete article steps; the home page keeps its group image."
