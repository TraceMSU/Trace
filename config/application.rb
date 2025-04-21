require "logger"       # ensure Logger is defined for ActiveSupport
require "bigdecimal"   # ensure BigDecimal is available for JSON, I18n, etc.
require_relative "boot"

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
# require "active_record/railtie"

Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Autoload and eager-load your lib/ directory
    config.paths.add "lib", eager_load: true
    config.autoload_paths << Rails.root.join("lib")

    # (You can drop the explicit app/models line if Rails is already picking it up)
    config.autoload_paths << Rails.root.join("app/models")

    # API‑only middleware (with CORS)
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("CORS_ORIGINS", "http://localhost:8080")
        resource "*",
          headers: :any,
          methods: %i[get post put patch delete options head],
          credentials: true
      end
    end

    # After Rails has booted, establish your Neo4j connection
    config.after_initialize do
      Neo4j::Driver::GraphDatabase.driver(
        ENV.fetch("NEO4J_URL",      "bolt://localhost:7687"),
        Neo4j::Driver::AuthTokens.basic(
          ENV.fetch("NEO4J_USERNAME", "neo4j"),
          ENV.fetch("NEO4J_PASSWORD", "Cheese100!")
        )
      )
    end
  end
end
