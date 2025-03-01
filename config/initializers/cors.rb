# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:your_flutter_port' # Replace with your Flutter port
      resource '*',
        headers: %w(Authorization Content-Type),
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end