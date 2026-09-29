All contributions, including merge requests, feature requests, ideas, design tweaks, etc. are welcome.
I welcome all input, from sharing your own implementations of code to general thoughts and ideas. Just open a new issue!

## Feature Requests

Feature requests are always welcome! If Jekyll can do it and if the theme's design would work well with it, then I would love to add it. Of course, code submission via a merge/pull request is great, but not necessary.

## Adding content to the SECQUOIA site

### Talks and tutorials

1. Add the slides as a PDF under `assets/pdf/`. Compress the export first with
   `scripts/compress_pdf.sh slides.pdf` (needs Ghostscript); PowerPoint exports
   usually shrink by 40% or more with no visible loss and keep their links.
2. Create a landing page under `talks/` with a `permalink` (for example
   `/cbctq2026-tutorial/`), the abstract, a link to the PDF, and links to any
   hands-on material. Set `nav-menu: false` and `show_tile: false` so it does
   not appear in the menu or the home page tiles.
3. Add an entry to `_data/talks.yml`. The Teaching page lists talks from that
   file, newest first, so this is the only place that needs editing for the
   talk to be discoverable on the site.
4. Add a news post under `_posts/` pointing at the landing page.

When a talk URL changes, keep the old one alive with the `jekyll-redirect-from`
plugin: add `redirect_from:` with the old path to the front matter of the page
that replaces it. Short stable aliases for external resources live in `talks/`
as pages with a `redirect_to:` (see `talks/qubo-notebooks.md`), so slides can
print a `secquoia.github.io/...` URL that keeps working if the target moves.

### Blog posts from LaTeX

1. Keep local copies of the article, bibliography, and included LaTeX files under
   `_sources/<post-slug>/`. This directory is ignored by Git and excluded from
   the published site. Commit the converted post and its website assets.
2. Create `_posts/YYYY-MM-DD-short-title.md` with `layout: post`, a title,
   description, date, and an existing or new WebP image. Posts appear
   automatically in the News archive. A `permalink` gives the article a stable URL.
3. Convert the prose to Markdown and resolve the BibTeX citations into linked
   references before committing. The deployed site does not run LaTeX,
   BibTeX, or Pandoc. Retain local source copies for future corrections.
4. Render equations with MathJax when needed. Check custom macros, cross-references,
   and every table row after conversion; complex LaTeX tables need manual
   adaptation. Give wide tables a scrollable wrapper and figures useful text
   alternatives. Reference raster figures in WebP format.
5. Check the page at desktop and phone widths, verify citations and asset links,
   and run `./validate.sh` before opening a draft PR. Resolve source TODOs before
   publishing. Use the PR's `preview-site` workflow artifact for review;
   screenshots can stay local under `_sources/`.

### Translated articles

Keep one canonical English post in `_posts/`.
Place translations under `articles/<post-slug>/<lang>.md` with `layout: post`, `lang`, the same `translation_key`, and a language-prefixed permalink.
Register every version in `_data/article_languages.yml` to show language links and alternate-language metadata.
Translations are pages so they do not duplicate the original item in the News archive.

Translate the complete article, including figure text, table descriptions, and status labels.
Preserve formulas, result IDs, reference IDs, citation targets, and the bibliography's original publication titles.
Keep one sentence per source line.
When the English text changes, update both translations in the same PR and regenerate any PDFs being shared.
Keep PDF exports local under `_sources/`; they are snapshots of the reviewed pages.

### Files and sizes

- Keep working files (`.pptx`, `.docx`, drafts, loose PDFs) out of the repository
  root. Jekyll copies unexcluded root files into the published site, and CI fails
  on tracked files of those types at the root.
- CI also fails on any tracked file above 20 MB. Git keeps every revision of a
  binary forever, so compress before committing and avoid re-committing a
  large file for small changes.

## Bug Reports

If you encounter any issues with these themes on any devices, please submit a bug report with the device type and a detailed description of what the issue that you're encountering is.
<br /><br />

*Thank you*