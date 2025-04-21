# config/application.rb
require "logger"       # ensure Logger is defined for ActiveSupport
require "bigdecimal"   # ensure BigDecimal is available
require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    # initialize defaults for Rails 7.0
    config.load_defaults 7.0

    # API only mode
    config.api_only = true

    # CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("CORS_ORIGINS", "http://localhost:8080")
        resource "*",
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end

    # Autoload your models and lib folder
    config.autoload_paths << Rails.root.join("app/models")
    config.paths.add "lib", eager_load: true

    # After Rails boots, establish the Neo4j connection
    config.after_initialize do
      Neo4j::Driver::GraphDatabase.driver(
        ENV.fetch("NEO4J_URL",      "bolt://localhost:7687"),
        Neo4j::Driver::AuthTokens.basic(
          ENV.fetch("NEO4J_USERNAME", "neo4j"),
          ENV.fetch("NEO4J_PASSWORD", "")
        )
      )
    end
  end
end
