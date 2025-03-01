# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # For development only, needs to be changed before production
      resource '*',
        headers: %w(Authorization Content-Type),
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end