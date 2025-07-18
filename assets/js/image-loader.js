// Optimized image loading with lazy loading and WebP support
document.addEventListener('DOMContentLoaded', function() {
  // First, add lazy loading to all images
  const images = document.querySelectorAll('img');
  images.forEach(img => {
    if (!img.hasAttribute('loading')) {
      img.setAttribute('loading', 'lazy');
    }
  });

  // Only proceed with WebP conversion if WebP is supported
  if (document.documentElement.classList.contains('webp')) {
    // Only convert regular <img> tags, not background images
    const convertibleImages = document.querySelectorAll('img:not([src$=".svg"]):not([src$=".webp"]):not([src$=".avif"])');
    
    // Replace each image source with WebP version if it exists
    convertibleImages.forEach(img => {
      const src = img.getAttribute('src');
      if (src && (src.endsWith('.jpg') || src.endsWith('.jpeg') || src.endsWith('.png'))) {
        // Create WebP path
        const webpSrc = src.substring(0, src.lastIndexOf('.')) + '.webp';
        
        // Create a pictureElement to wrap the image with WebP source
        const picture = document.createElement('picture');
        const source = document.createElement('source');
        source.srcset = webpSrc;
        source.type = 'image/webp';
        
        // Clone original attributes including lazy loading
        const imgClone = img.cloneNode(true);
        
        // Replace the image with picture element
        picture.appendChild(source);
        picture.appendChild(imgClone);
        img.parentNode.replaceChild(picture, img);
      }
    });
  }
});