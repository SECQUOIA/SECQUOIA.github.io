---
---
const CACHE_NAME = 'secquoia-v2';
const urlsToCache = [
  '/',
  '/assets/css/main.css',
  '/assets/css/font-awesome.min.css',
  '/assets/js/main.js',
  '/assets/js/jquery.min.js',
  '/assets/js/util.js',
  '/assets/js/skel.min.js',
  '/assets/js/jquery.scrolly.min.js',
  '/assets/js/jquery.scrollex.min.js',
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
      .then(function() {
        // Activate immediately
        return self.skipWaiting();
      })
  );
});

// Fetch event - network first, fall back to cache
self.addEventListener('fetch', function(event) {
  event.respondWith(
    fetch(event.request)
      .then(function(response) {
        // Clone the response
        const responseToCache = response.clone();
        
        // Only cache successful responses
        if (response.status === 200) {
          caches.open(CACHE_NAME)
            .then(function(cache) {
              cache.put(event.request, responseToCache);
            });
        }
        
        return response;
      })
      .catch(function() {
        // If network fails, try cache
        return caches.match(event.request);
      })
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
    }).then(function() {
      // Take control immediately
      return self.clients.claim();
    })
  );
});