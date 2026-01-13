FROM ruby:3.2
WORKDIR /app

# Install system dependencies for validation
RUN apt-get update && apt-get install -y yamllint && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock* ./
RUN gem install bundler && bundle install
COPY . .
EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
