---
layout: page
title: Publications
image: assets/images/books.webp
description: 'Journal Articles, Proceedings, Books, Preprints, and Presentations'
nav-menu: true
banner_color: style3
redirect_from:
  - /publications/articles.html
  - /publications/conferences.html
  - /publications/others.html
---

<!-- markdownlint-disable MD033 -->

<style>
.pub-controls {
  margin: 1.5rem 0 2rem;
  padding: 1.25rem;
  background: var(--fill);
  border: 1px solid var(--border);
  border-radius: 6px;
}

.pub-filter-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.pub-filter-btn {
  font-size: 0.72rem;
  height: 2.5em;
  line-height: 2.5em;
  padding: 0 1em;
}

.pub-filter-btn[aria-pressed="true"] {
  background-color: var(--highlight);
  box-shadow: none;
  color: var(--bg) !important;
}

.pub-search-row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem 1rem;
}

.pub-search-row label {
  margin: 0;
  font-size: 0.85rem;
}

.pub-search-row input[type="search"] {
  flex: 1 1 18rem;
  height: 2.5em;
}

.pub-filter-status {
  margin: 0.65rem 0 0;
  font-size: 0.88rem;
  color: var(--fg-light);
}

.pub-year-group {
  margin-top: 2rem;
}

.pub-year-heading {
  border-bottom: 2px solid var(--border);
  padding-bottom: 0.25rem;
  margin-bottom: 1rem;
}

.publications-list li.pub-item {
  margin-bottom: 0.9rem;
  line-height: 1.6;
}

.pub-meta-actions {
  display: inline-flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.35rem;
  margin-left: 0.35rem;
  vertical-align: baseline;
}

.pub-type-badge,
.pub-badge {
  display: inline-block;
  font-size: 0.72rem;
  font-weight: 600;
  line-height: 1.4;
  padding: 0.1rem 0.48rem;
  border-radius: 4px;
  border: 1px solid var(--border);
  text-decoration: none !important;
}

.pub-type-badge {
  background: var(--fill);
  color: var(--fg-light);
}

a.pub-badge,
summary.pub-badge {
  color: var(--link);
  background: var(--bg);
  cursor: pointer;
}

a.pub-badge:hover,
summary.pub-badge:hover {
  border-color: var(--highlight);
  color: var(--highlight) !important;
}

details.pub-bibtex {
  display: inline-block;
}

details.pub-bibtex[open] {
  display: block;
  width: 100%;
  margin-top: 0.5rem;
}

details.pub-bibtex pre {
  margin: 0.4rem 0 0.5rem;
  padding: 0.75rem 1rem;
  font-size: 0.8rem;
  overflow-x: auto;
  background: var(--code-bg, var(--fill));
  border: 1px solid var(--border);
  border-radius: 4px;
}

.pub-copy-btn {
  font-size: 0.68rem;
  height: 2.2em;
  line-height: 2.2em;
  padding: 0 0.85em;
  margin-left: 0.5rem;
}

.pub-year-group[hidden],
.pub-item[hidden],
.pub-controls[hidden] {
  display: none !important;
}
</style>

<section id="overview">
 <div class="inner">
  <header class="major">
   <h2>Scholarly Output</h2>
  </header>
  <p>
   Peer-reviewed journal articles, conference proceedings, books and chapters, preprints, software releases, theses, and conference presentations from SECQUOIA and Prof. David E. Bernal Neira. For live citation metrics, see <a href="https://scholar.google.com/citations?user=8s6SR7YAAAAJ&amp;hl=en" target="_blank" rel="noopener noreferrer">Google Scholar</a> and <a href="https://orcid.org/0000-0002-8308-5016" target="_blank" rel="noopener noreferrer">ORCID</a>.
  </p>

  <div class="pub-controls" id="pub-controls" hidden>
   <div class="pub-filter-buttons" role="group" aria-label="Filter publications by category">
    <button type="button" class="button small pub-filter-btn" data-filter="all" aria-pressed="true">All</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Journal Article" aria-pressed="false">Journal Articles</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Conference Proceedings" aria-pressed="false">Conference Proceedings</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Preprint" aria-pressed="false">Preprints</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Book / Chapter" aria-pressed="false">Books &amp; Chapters</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Software" aria-pressed="false">Software</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Thesis" aria-pressed="false">Theses</button>
    <button type="button" class="button small pub-filter-btn" data-filter="Presentation" aria-pressed="false">Presentations</button>
   </div>
   <div class="pub-search-row">
    <label for="pub-search">Search</label>
    <input type="search" id="pub-search" placeholder="Filter by title, author, journal, year, or keyword..." autocomplete="off" />
   </div>
   <p class="pub-filter-status" id="pub-filter-status" aria-live="polite"></p>
  </div>

  {% include publications style="apa" link=true group_by_year=true %}
 </div>
</section>

<section>
 <div class="inner">
  <ul class="actions">
   <li><a href="/5-research.html" class="button">Explore Research Themes</a></li>
   <li><a href="/6-software.html" class="button">Open-Source Software</a></li>
   <li><a href="/#launch" class="button icon fa-arrow-left">Go back to launch page</a></li>
  </ul>
 </div>
</section>

<script>
(function () {
  var controls = document.getElementById('pub-controls');
  if (!controls) return;
  controls.hidden = false;

  var buttons = Array.prototype.slice.call(controls.querySelectorAll('.pub-filter-btn'));
  var searchInput = document.getElementById('pub-search');
  var statusEl = document.getElementById('pub-filter-status');
  var items = Array.prototype.slice.call(document.querySelectorAll('.pub-item'));
  var groups = Array.prototype.slice.call(document.querySelectorAll('.pub-year-group'));
  var activeType = 'all';

  function applyFilters() {
    var query = (searchInput.value || '').trim().toLowerCase();
    var shown = 0;

    items.forEach(function (item) {
      var itemType = item.getAttribute('data-type') || '';
      var matchesType = (activeType === 'all') || (itemType === activeType);
      var matchesQuery = !query || (item.textContent || '').toLowerCase().indexOf(query) !== -1;
      var visible = matchesType && matchesQuery;
      item.hidden = !visible;
      if (visible) shown += 1;
    });

    groups.forEach(function (group) {
      var anyVisible = group.querySelector('.pub-item:not([hidden])') !== null;
      group.hidden = !anyVisible;
    });

    if (statusEl) {
      statusEl.textContent = 'Showing ' + shown + ' of ' + items.length + ' entries.';
    }
  }

  buttons.forEach(function (btn) {
    btn.addEventListener('click', function () {
      activeType = btn.getAttribute('data-filter') || 'all';
      buttons.forEach(function (b) {
        b.setAttribute('aria-pressed', b === btn ? 'true' : 'false');
      });
      applyFilters();
    });
  });

  if (searchInput) {
    searchInput.addEventListener('input', applyFilters);
  }

  document.querySelectorAll('details.pub-bibtex').forEach(function (det) {
    var summary = det.querySelector('summary');
    var codeEl = det.querySelector('code');
    if (!summary || !codeEl || !navigator.clipboard) return;
    var copyBtn = document.createElement('button');
    copyBtn.type = 'button';
    copyBtn.className = 'button small pub-copy-btn';
    copyBtn.textContent = 'Copy BibTeX';
    copyBtn.addEventListener('click', function () {
      navigator.clipboard.writeText(codeEl.textContent || '').then(function () {
        copyBtn.textContent = 'Copied!';
        setTimeout(function () { copyBtn.textContent = 'Copy BibTeX'; }, 1800);
      });
    });
    det.appendChild(copyBtn);
  });

  applyFilters();
})();
</script>
