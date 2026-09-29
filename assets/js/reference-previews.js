// Shows a reference's full entry when a citation link is hovered or keyboard-focused.
// Touch screens keep the default behaviour: tapping a citation jumps to the reference list.
(function () {
  if (!window.matchMedia('(hover: hover)').matches) return;

  var links = document.querySelectorAll('a[href^="#ref-"]');
  if (!links.length) return;

  var popup = document.createElement('div');
  popup.id = 'reference-preview';
  popup.className = 'reference-preview';
  popup.setAttribute('role', 'tooltip');
  popup.hidden = true;
  document.body.appendChild(popup);

  var current = null;
  var hideTimer;

  function show(link) {
    var entry = document.getElementById(decodeURIComponent(link.hash.slice(1)));
    if (!entry) return;
    clearTimeout(hideTimer);
    hide();

    var body = entry.querySelector('.csl-right-inline') || entry;
    popup.innerHTML = body.innerHTML;
    popup.lang = body.closest('[lang]').lang;
    popup.hidden = false;
    link.setAttribute('aria-describedby', popup.id);
    current = link;

    // Place below the link, or above it when there is no room below; keep it inside the viewport.
    var rect = link.getBoundingClientRect();
    var margin = 8;
    var viewportWidth = document.documentElement.clientWidth;
    var left = rect.left + rect.width / 2 - popup.offsetWidth / 2;
    left = Math.max(margin, Math.min(left, viewportWidth - popup.offsetWidth - margin));
    var top = rect.bottom + margin;
    if (top + popup.offsetHeight > window.innerHeight && rect.top - popup.offsetHeight - margin > 0) {
      top = rect.top - popup.offsetHeight - margin;
    }
    popup.style.left = left + window.scrollX + 'px';
    popup.style.top = top + window.scrollY + 'px';
  }

  function hide() {
    popup.hidden = true;
    if (current) current.removeAttribute('aria-describedby');
    current = null;
  }

  // A short delay lets the pointer move from the link into the preview to click its links.
  function hideSoon() {
    hideTimer = setTimeout(hide, 200);
  }

  links.forEach(function (link) {
    link.addEventListener('mouseenter', function () { show(link); });
    link.addEventListener('mouseleave', hideSoon);
    link.addEventListener('focus', function () { show(link); });
    link.addEventListener('blur', hideSoon);
  });
  popup.addEventListener('mouseenter', function () { clearTimeout(hideTimer); });
  popup.addEventListener('mouseleave', hideSoon);
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') hide();
  });
})();
