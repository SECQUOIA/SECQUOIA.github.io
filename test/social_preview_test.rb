# Check the generated pages: social crawlers must see the article diagram,
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
  suffix = "/assets/images/ai-agents-research/social-#{language}.png"
  unless uri.is_a?(URI::HTTPS) && uri.host && uri.path.end_with?(suffix)
    abort "#{language}: expected an absolute diagram URL ending in #{suffix}, got #{image}"
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

  # The illustrated overview supplements the complete, selectable instructions.
  figure = document.at_css("#research-setup")
  inline = figure&.at_css("a.research-diagram img")
  unless inline && URI(inline["src"]).path.end_with?(suffix.sub(/\.png$/, ".webp"))
    abort "#{language}: article does not embed its own illustrated banner"
  end
  unless URI(inline.parent["href"]).path.end_with?(suffix) && inline["width"] == width.to_s && inline["height"] == height.to_s
    abort "#{language}: full-size banner link or inline dimensions differ"
  end
  steps = figure.css(".research-steps > li")
  unless steps.length == 3 && steps.all? { |step| step.at_css("h3") && !step.at_css("p")&.text.to_s.strip.empty? }
    abort "#{language}: the complete original step list must remain beside the illustration"
  end
end

home = Nokogiri::HTML(File.read(File.join(site_dir, "index.html")))
%w[og:image twitter:image].each do |property|
  image = URI(meta(home, property))
  unless image.is_a?(URI::HTTPS) && image.host && image.path.end_with?("/assets/images/group2024.jpg")
    abort "Home page lost its default group image: #{property}"
  end
end

puts "Social previews use localized article diagrams with valid assets; the home page keeps its group image."
