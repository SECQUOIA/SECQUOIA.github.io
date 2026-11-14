/*
	Forty by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

(function($) {

	skel.breakpoints({
		xlarge: '(max-width: 1680px)',
		large: '(max-width: 1280px)',
		medium: '(max-width: 980px)',
		small: '(max-width: 736px)',
		xsmall: '(max-width: 480px)',
		xxsmall: '(max-width: 360px)'
	});

	/**
	 * Applies parallax scrolling to an element's background image.
	 * @return {jQuery} jQuery object.
	 */
	$.fn._parallax = (skel.vars.browser == 'ie' || skel.vars.browser == 'edge' || skel.vars.mobile || (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches)) ? function() { return $(this) } : function(intensity) {

		var	$window = $(window),
			$this = $(this);

		if (this.length == 0 || intensity === 0)
			return $this;

		if (this.length > 1) {

			for (var i=0; i < this.length; i++)
				$(this[i])._parallax(intensity);

			return $this;

		}

		if (!intensity)
			intensity = 0.25;

		$this.each(function() {

			var $t = $(this),
				on, off;

			on = function() {

				$t.css('background-position', 'center 100%, center 100%, center 0px');

				$window
					.on('scroll._parallax', function() {

						var pos = parseInt($window.scrollTop()) - parseInt($t.position().top);

						$t.css('background-position', 'center ' + (pos * (-1 * intensity)) + 'px');

					});

			};

			off = function() {

				$t
					.css('background-position', '');

				$window
					.off('scroll._parallax');

			};

			skel.on('change', function() {

				if (skel.breakpoint('medium').active)
					(off)();
				else
					(on)();

			});

		});

		$window
			.off('load._parallax resize._parallax')
			.on('load._parallax resize._parallax', function() {
				$window.trigger('scroll');
			});

		return $(this);

	};

	$(function() {

		var	$window = $(window),
			$body = $('body'),
			$wrapper = $('#wrapper'),
			$header = $('#header'),
			$banner = $('#banner');

		// Fix: Enable IE-only tweaks.
			if (skel.vars.browser == 'ie' || skel.vars.browser == 'edge')
				$body.addClass('is-ie');

		// Fix: Placeholder polyfill.
			$('form').placeholder();

		// Prioritize "important" elements on medium.
			skel.on('+medium -medium', function() {
				$.prioritize(
					'.important\\28 medium\\29',
					skel.breakpoint('medium').active
				);
			});

		// Scrolly.
			$('.scrolly').scrolly({
				offset: function() {
					return $header.height() - 2;
				}
			});

		// Apply data-position alignment to native lazy-loaded tile images without intercepting clicks.
			$('.tiles > article > .image > img[data-position]').each(function() {
				var $img = $(this);
				$img.css('object-position', $img.data('position'));
			});

		// Remove redundant tab stops on any remaining self-referential spotlight image anchors.
			$('.spotlights a.image[href^="#"]').each(function() {
				var $a = $(this),
					targetId = $a.attr('href').slice(1);
				if (targetId && $a.closest('section#' + targetId).length > 0) {
					$a.attr({ 'tabindex': '-1', 'aria-hidden': 'true' });
				}
			});

		// Header.
			if (skel.vars.IEVersion < 9)
				$header.removeClass('alt');

			if ($banner.length > 0
			&&	$header.hasClass('alt')) {

				$window.on('resize', function() {
					$window.trigger('scroll');
				});

				$window.on('load', function() {

					$banner.scrollex({
						bottom:		$header.height() + 10,
						terminate:	function() { $header.removeClass('alt'); },
						enter:		function() { $header.addClass('alt'); },
						leave:		function() { $header.removeClass('alt'); $header.addClass('reveal'); }
					});

					window.setTimeout(function() {
						$window.triggerHandler('scroll');
					}, 100);

				});

			}

		// Banner parallax on background-image banners only (Home).
			$banner.each(function() {
				var $this = $(this);
				if ($this.children('.image').length === 0)
					$this._parallax(0.275);
			});

		// Menu.
			var $menu = $('#menu'),
				$menuToggle = $('#header .menu-toggle, #header a[href="#menu"]'),
				$menuInner,
				$closeBtn;

			$menu.wrapInner('<div class="inner"></div>');
			$menuInner = $menu.children('.inner');
			$menu._locked = false;

			$menu._lock = function() {

				if ($menu._locked)
					return false;

				$menu._locked = true;

				window.setTimeout(function() {
					$menu._locked = false;
				}, 350);

				return true;

			};

			$menu._setOpenState = function(isOpen, restoreFocus) {
				var $bgRegions = $wrapper.add('.skip-link');
				$menuToggle.attr('aria-expanded', isOpen ? 'true' : 'false');
				$bgRegions.each(function() {
					this.inert = !!isOpen;
					if (isOpen)
						$(this).attr('aria-hidden', 'true');
					else
						$(this).removeAttr('aria-hidden');
				});
				if (isOpen) {
					window.setTimeout(function() {
						var $firstLink = $menu.find('a, button').first();
						if ($firstLink.length > 0)
							$firstLink[0].focus();
					}, 50);
				} else if (restoreFocus && $menuToggle.length > 0) {
					$menuToggle[0].focus();
				}
			};

			$menu._show = function() {

				if ($menu._lock()) {
					$body.addClass('is-menu-visible');
					$menu._setOpenState(true, false);
				}

			};

			$menu._hide = function(restoreFocus) {

				if (!$body.hasClass('is-menu-visible'))
					return;

				if ($menu._lock()) {
					$body.removeClass('is-menu-visible');
					$menu._setOpenState(false, !!restoreFocus);
				}

			};

			$menu._toggle = function() {

				if ($body.hasClass('is-menu-visible'))
					$menu._hide(true);
				else
					$menu._show();

			};

			$menuInner
				.on('click', function(event) {
					event.stopPropagation();
				})
				.on('click', 'a', function(event) {
					if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || event.which > 1)
						return;
					event.stopPropagation();
					$menu._hide(false);
				});

			$closeBtn = $('<button type="button" class="close" aria-label="Close menu">Close</button>');
			$closeBtn.on('click', function(event) {
				event.stopPropagation();
				event.preventDefault();
				$menu._hide(true);
			});

			$menu
				.appendTo($body)
				.on('click', function(event) {

					event.stopPropagation();
					event.preventDefault();

					$menu._hide(true);

				})
				.append($closeBtn);

			$body
				.on('click', 'a[href="#menu"], button.menu-toggle', function(event) {

					event.stopPropagation();
					event.preventDefault();

					// Toggle.
						$menu._toggle();

				})
				.on('click', function(event) {

					// Hide.
						$menu._hide(false);

				})
				.on('keydown', function(event) {

					if (!$body.hasClass('is-menu-visible'))
						return;

					// Hide on escape.
						if (event.key === 'Escape' || event.keyCode == 27) {
							event.preventDefault();
							$menu._hide(true);
							return;
						}

					// Keep Tab / Shift+Tab focus within the open modal menu.
						if (event.key === 'Tab' || event.keyCode == 9) {
							var $focusable = $menu.find('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])').filter(':visible');
							if ($focusable.length === 0)
								return;
							var firstEl = $focusable[0],
								lastEl = $focusable[$focusable.length - 1];
							if (event.shiftKey && (document.activeElement === firstEl || !$menu[0].contains(document.activeElement))) {
								event.preventDefault();
								lastEl.focus();
							} else if (!event.shiftKey && (document.activeElement === lastEl || !$menu[0].contains(document.activeElement))) {
								event.preventDefault();
								firstEl.focus();
							}
						}

				});

	});

})(jQuery);
