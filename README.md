# SECQUOIA.github.io

The webpage of [SECQUOIA](https://SECQUOIA.github.io/) (Systems Engineering via Classical and Quantum Optimization for Industrial Applications) research group at Purdue University.

## Local Development with Docker

Follow these instructions to set up and run the website locally using Docker.

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- Git

### Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/SECQUOIA/SECQUOIA.github.io.git
   cd SECQUOIA.github.io
   ```

2. **Build the Docker image**

   ```bash
   docker build -t secquoia-website .
   ```

3. **Run the website locally**

   ```bash
   docker run --rm -it -p 4000:4000 -v "$(pwd)":/app secquoia-website
   ```

4. **View the website**

   Open your web browser and go to [http://localhost:4000](http://localhost:4000)

### Development Workflow

When making changes to the website:

1. Keep the Docker container running
2. Edit files in your favorite editor
3. Changes will be automatically detected and the site will rebuild
4. Refresh your browser to see changes

To enable live reloading, stop any running containers and run:

```bash
docker run --rm -it -p 4000:4000 -v "$(pwd)":/app secquoia-website bundle exec jekyll serve --livereload --host 0.0.0.0
```

### Building for Production

To build the site for production:

```bash
docker run --rm -v "$(pwd)":/app secquoia-website bundle exec jekyll build
```

The built site will be in the `_site` directory, which can be deployed to any static hosting service.

### Native Ruby (Optional)

If you prefer not to use Docker:

```bash
bundle install
bundle exec jekyll serve --livereload
```

### Validation

Run the repository validation script before opening a PR:

```bash
bash validate.sh
```

### Troubleshooting

- If you encounter permission issues with Docker, ensure your user is added to the Docker group:
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  ```

- If there are bundle dependency issues, try rebuilding the Docker image:
  ```bash
  docker build --no-cache -t secquoia-website .
  ```

## Image Policy (WebP Usage)

We store original images (PNG/JPG/etc.) in the repository for provenance, but **only WebP images should be referenced in the built site**.

Enforcement model:
1. CI scans generated `_site` HTML for `<img>` tags referencing non-WebP files under `assets/images/`.
2. If any referenced image ends with `.png`, `.jpg`, `.jpeg`, or `.gif`, the build fails.
3. You may still commit original source images alongside their converted `.webp` counterpart.

Conversion examples:

```bash
# Using cwebp (preferred)
cwebp input.jpg -q 80 -o input.webp

# Using ImageMagick
magick input.png -quality 80 input.webp
```

Update references (Markdown or HTML) to point to the `.webp` file after conversion.

Local pre-check after building:

```bash
bundle exec jekyll build
bash scripts/check_referenced_images.sh
```

Tips:
- Target WebP quality (~70–85) balancing size vs clarity.
- Keep typical member photos < 300KB; large hero/banner images ideally < 1MB.
- Original files can remain for future recompression or alternative formats if needed.
