---
---
const CACHE_NAME = 'secquoia-v1';
const urlsToCache = [
  '/',
  '/assets/css/main.css',
  '/assets/js/main.js',
  '/assets/js/jquery.min.js',
  '/assets/js/util.js',
  '/assets/images/banner.webp',
  '/assets/images/group2024.webp',
  '/assets/fonts/fontawesome-webfont.woff2'
];

// Install event - cache resources
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        return cache.addAll(urlsToCache);
      })
  );
});

// Fetch event - serve cached content when offline
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request)
      .then(function(response) {
        // Return cached version or fetch from network
        return response || fetch(event.request);
      }
    )
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});