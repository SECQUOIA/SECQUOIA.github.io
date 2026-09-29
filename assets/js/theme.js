// Run before stylesheets to apply a saved preference before the first paint.
(function () {
  'use strict';
  var root = document.documentElement;
  var system = window.matchMedia('(prefers-color-scheme: dark)');
  var preference = null;
  var key = 'secquoia-theme';

  function valid(value) { return value === 'light' || value === 'dark'; }
  try {
    var saved = localStorage.getItem(key);
    if (valid(saved)) preference = saved;
  } catch (error) {
    // Theme switching still works when browser storage is unavailable.
  }

  function apply() {
    var theme = preference || (system.matches ? 'dark' : 'light');
    root.dataset.theme = theme;
    var button = document.getElementById('theme-toggle');
    if (button) {
      button.setAttribute('aria-pressed', String(theme === 'dark'));
      button.hidden = false;
    }
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) meta.content = theme === 'dark' ? '#202122' : '#faf9f6';
  }
  apply();

  document.addEventListener('DOMContentLoaded', function () {
    var button = document.getElementById('theme-toggle');
    if (button) button.addEventListener('click', function (event) {
      event.stopPropagation();
      preference = root.dataset.theme === 'dark' ? 'light' : 'dark';
      try { localStorage.setItem(key, preference); } catch (error) {}
      apply();
    });
    apply();
  });
  system.addEventListener('change', function () { if (!preference) apply(); });
  window.addEventListener('storage', function (event) {
    if (event.key === key || event.key === null) {
      preference = valid(event.newValue) ? event.newValue : null;
      apply();
    }
  });
}());
