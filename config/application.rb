# config/application.rb

require "logger"       # ensure Logger is defined for ActiveSupport
require "bigdecimal"   # ensure BigDecimal is available
require_relative "boot"

# Pick only the frameworks you actually use:
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_support/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
# require "active_record/railtie"     # <— comment this out if you’re not using AR
# require "active_storage/engine"
# require "action_mailbox/engine"
# require "action_text/engine"

Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7.0
    config.load_defaults 7.0

    # API‑only mode
    config.api_only = true

    # Autoload your models and lib/
    config.autoload_paths << Rails.root.join("app/models")
    config.paths.add "lib", eager_load: true

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

    # After Rails has booted, hook up your Neo4j driver
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
