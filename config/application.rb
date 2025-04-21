require "logger"       # ensure Logger is defined for ActiveSupport
require "bigdecimal"   # ensure BigDecimal is available for JSON, I18n, etc.
require_relative "boot"

require "rails/all"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_support/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
#require "active_record/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Now load Neo4j related components
require "active_support/all"
require "neo4j/driver"
module Workspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.

    config.autoload_lib(ignore: %w(assets tasks))
    config.autoload_paths += %W(#{config.root}/app/models)
  
    # Configuration for the application, engines, and railties goes here.
    # i want to require 'active_graph' in railties.rb upon setup 
    
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # Add inside the Application class
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV['CORS_ORIGINS'] || 'http://localhost:8080'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end
    # Establish connection using ActiveGraph's preferred method
    # Establish the connection using establish_driver
    # Establish the Neo4j connection using the Neo4j::Driver::GraphDatabase.driver method
    # Establish the Neo4j connection using the Neo4j::Driver::AuthTokens.basic method
    Neo4j::Driver::GraphDatabase.driver(
    ENV['NEO4J_URL'] || 'bolt://localhost:7687', # URL of your Neo4j instance
    Neo4j::Driver::AuthTokens.basic(
    ENV['NEO4J_USERNAME'] || 'neo4j', # Neo4j username
    ENV['NEO4J_PASSWORD'] || 'Cheese100!' # Neo4j password
  )
)
  end
end
