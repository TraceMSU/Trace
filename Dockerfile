# syntax = docker/dockerfile:1

# Define the Ruby version to use in the image
ARG RUBY_VERSION=3.2.5
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

# Expose port 3000 for the Rails server
EXPOSE 3000

# Set the working directory for the app
WORKDIR /workspace

# Install Node.js, Yarn, and essential system dependencies including Chrome and ChromeDriver
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update -qq && \
    apt-get install -y git nodejs yarn build-essential libvips sqlite3 \
    chromium-driver chromium libgconf-2-4 libnss3 fonts-liberation libxss1 \
    libappindicator3-1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libx11-xcb1 \
    libxcomposite1 libxrandr2 libxdamage1 libxkbcommon0 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install Bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the Docker image
COPY Gemfile Gemfile.lock ./
COPY lib/data/testdata.xlsx /rails/lib/data/testdata.xls
COPY . /workspace

# Install the required gems
RUN bundle install

# Set PATH so that /usr/local/bin is first (ensuring our wrapper is used)
ENV PATH="/usr/local/bin:${PATH}"

# Create a wrapper script for 'rails' in /usr/local/bin using printf and convert to LF
RUN apt-get update && apt-get install -y dos2unix && \
    printf '#!/bin/sh\nexec /usr/local/bundle/bin/rails "$@"\n' > /usr/local/bin/rails && \
    dos2unix /usr/local/bin/rails && \
    chmod +x /usr/local/bin/rails

# Set default entry command to a bash shell
CMD ["bash"]