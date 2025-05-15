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

2. **Create a Dockerfile**

   Create a file named `Dockerfile` with the following content:

   ```dockerfile
   FROM ruby:3.2
   WORKDIR /app
   COPY . .
   RUN gem install bundler && bundle install
   EXPOSE 4000
   CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
   ```

3. **Create a Gemfile**

   Create a file named `Gemfile` with the following content:

   ```ruby
   source "https://rubygems.org"
   
   gem "jekyll", "~> 4.0.0"
   gem "mercenary", "~> 0.3.6"
   gem "webrick"
   gem "forty_jekyll_theme", path: "."
   ```

4. **Build the Docker image**

   ```bash
   docker build -t secquoia-website .
   ```

5. **Run the website locally**

   ```bash
   docker run -p 4000:4000 -v "$(pwd)":/app secquoia-website
   ```

6. **View the website**

   Open your web browser and go to [http://localhost:4000](http://localhost:4000)

### Development Workflow

When making changes to the website:

1. Keep the Docker container running
2. Edit files in your favorite editor
3. Changes will be automatically detected and the site will rebuild
4. Refresh your browser to see changes

To enable live reloading, stop any running containers and run:

```bash
docker run -p 4000:4000 -v "$(pwd)":/app secquoia-website bundle exec jekyll serve --livereload --host 0.0.0.0
```

### Building for Production

To build the site for production:

```bash
docker run -v "$(pwd)":/app secquoia-website bundle exec jekyll build
```

The built site will be in the `_site` directory, which can be deployed to any static hosting service.

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

### Important Note

The Dockerfile, Gemfile, and other development configuration files are gitignored to keep the repository clean. You'll need to recreate them when setting up a new development environment.
