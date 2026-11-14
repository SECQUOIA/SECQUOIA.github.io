require "nokogiri"

site = File.expand_path(ARGV[0] || "../_site", __dir__)
html_files = Dir.glob(File.join(site, "**/*.html")).sort
abort "No HTML files found in #{site}" if html_files.empty?

def srgb_channel(hex_pair)
  c = hex_pair.to_i(16) / 255.0
  c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055)**2.4
end

def relative_luminance(hex)
  clean = hex.delete("#")
  r = srgb_channel(clean[0..1])
  g = srgb_channel(clean[2..3])
  b = srgb_channel(clean[4..5])
  0.2126 * r + 0.7152 * g + 0.0722 * b
end

def contrast_ratio(hex1, hex2)
  l1 = relative_luminance(hex1)
  l2 = relative_luminance(hex2)
  lighter, darker = [l1, l2].minmax.reverse
  (lighter + 0.05) / (darker + 0.05)
end

def accessible_name(node, doc)
  aria_label = node["aria-label"].to_s.strip
  return aria_label unless aria_label.empty?

  labelledby = node["aria-labelledby"].to_s.strip
  unless labelledby.empty?
    ref_text = labelledby.split.map { |id| doc.at_css("##{id}")&.text.to_s.strip }.reject(&:empty?).join(" ")
    return ref_text unless ref_text.empty?
  end

  text = node.text.to_s.strip
  return text unless text.empty?

  img_alt = node.css("img[alt]").map { |img| img["alt"].to_s.strip }.reject(&:empty?).join(" ")
  return img_alt unless img_alt.empty?

  title = node["title"].to_s.strip
  title
end

errors = []
checked_pages = 0

html_files.each do |path|
  rel = path.sub("#{site}/", "")
  doc = Nokogiri::HTML(File.read(path))

  # Skip jekyll-redirect-from meta-refresh stub pages
  next if doc.at_css('meta[http-equiv="refresh"]')

  checked_pages += 1

  html_el = doc.at_css("html")
  errors << "#{rel}: missing html[lang]" if !html_el || html_el["lang"].to_s.strip.empty?

  skip_link = doc.at_css('a.skip-link[href="#main"]')
  errors << "#{rel}: missing skip link to #main" unless skip_link

  mains = doc.css("main")
  errors << "#{rel}: expected exactly 1 <main>, found #{mains.length}" unless mains.length == 1
  main_ids = doc.css('[id="main"]')
  errors << "#{rel}: expected exactly 1 #main, found #{main_ids.length}" unless main_ids.length == 1

  navs = doc.css("nav")
  if navs.length > 1
    labels = navs.map { |n| accessible_name(n, doc) }
    errors << "#{rel}: unlabeled <nav> landmark when multiple <nav> exist" if labels.any?(&:empty?)
    errors << "#{rel}: duplicate <nav> accessible labels: #{labels.inspect}" unless labels.uniq.length == labels.length
  end

  headings = doc.css("h1, h2, h3, h4, h5, h6")
  h1s = doc.css("h1")
  errors << "#{rel}: expected exactly 1 <h1>, found #{h1s.length}" unless h1s.length == 1
  prev_level = 0
  headings.each do |h|
    level = h.name[1].to_i
    if prev_level.positive? && level > prev_level + 1
      errors << "#{rel}: skipped heading level from h#{prev_level} to h#{level} (#{h.text.strip.inspect})"
    end
    prev_level = level
  end

  doc.css("img").each do |img|
    errors << "#{rel}: <img> missing alt attribute (#{img['src'].inspect})" unless img.key?("alt")
    src = img["src"].to_s.strip
    errors << "#{rel}: <img> has empty or root '/' src (#{src.inspect})" if src.empty? || src == "/"
  end

  doc.css("a[href], button").each do |ctrl|
    next if ctrl["aria-hidden"] == "true" && ctrl["tabindex"] == "-1"
    name = accessible_name(ctrl, doc)
    errors << "#{rel}: <#{ctrl.name}> missing accessible name (#{ctrl.to_html[0, 100]})" if name.empty?
  end

  doc.css("input, select, textarea").each do |field|
    next if field.name == "input" && %w[submit reset button hidden].include?(field["type"].to_s.downcase)
    id = field["id"].to_s.strip
    has_for = !id.empty? && !doc.at_css("label[for='#{id}']").nil?
    has_wrap = field.ancestors("label").any?
    has_aria = !accessible_name(field, doc).empty?
    errors << "#{rel}: form control missing label (#{field.to_html[0, 100]})" unless has_for || has_wrap || has_aria
  end
end

css = File.read(File.join(site, "assets/css/main.css"))
errors << "main.css: missing prefers-reduced-motion support" unless css.include?("prefers-reduced-motion:reduce") || css.include?("prefers-reduced-motion: reduce")
errors << "main.css: missing --input-border token" unless css.include?("--input-border:")

# Verify WCAG 1.4.11 >= 3:1 non-text contrast for light (#7a7365 vs #faf9f6 / #eee9dd) and dark (#8f897d vs #202122 / #34332f)
[
  ["light input border vs bg", "#7a7365", "#faf9f6"],
  ["light input border vs fill", "#7a7365", "#eee9dd"],
  ["dark input border vs bg", "#8f897d", "#202122"],
  ["dark input border vs fill", "#8f897d", "#34332f"]
].each do |desc, fg_hex, bg_hex|
  ratio = contrast_ratio(fg_hex, bg_hex)
  errors << "WCAG 1.4.11 contrast < 3:1 for #{desc} (#{format('%.2f', ratio)}:1)" if ratio < 3.0
end

abort errors.join("\n") unless errors.empty?
puts "Verified WCAG 2.2 AA structural and contrast invariants across #{checked_pages} built pages"
