# config/puma.rb

# Puma can serve each request in a thread from an internal thread pool.
# The 'threads' method setting takes two numbers: a minimum and maximum.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }.to_i
threads min_threads_count, max_threads_count

# Default to development if RAILS_ENV isn't set
rails_env = ENV.fetch("RAILS_ENV") { "development" }

# In production, enable multiple workers or preload for copy‑on‑write
if rails_env == "production"
  # Number of worker processes (match dyno size)
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 1 })
  if worker_count > 1
    workers worker_count
  else
    preload_app!
  end
end

# In development, allow long worker timeouts (for debugging)
worker_timeout 3600 if rails_env == "development"

# Bind to the port specified by Heroku (or default to 3000 locally)
port ENV.fetch("PORT") { 3000 }

# Use the correct Rails environment
environment rails_env

# Specify a pidfile so `bin/rails restart` works
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow puma to be restarted by `bin/rails restart` command
plugin :tmp_restart
