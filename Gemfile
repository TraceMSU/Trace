source "https://rubygems.org"

ruby "3.4.2"

gem 'rails', '7.1.2'
gem 'activesupport', '7.1.2'


gem 'neo4j-ruby-driver', '4.4.5'
# ORM layer so `include Neo4j::ActiveNode` works:
gem 'activegraph', '~> 10.0'

gem 'i18n', '~> 1.14', '>= 1.14.7'
gem 'puma', '>= 6.6.0'
gem 'rack-cors'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'debug', platforms: %i[mri windows]
end

group :production do
  gem 'pg', '~> 1.4'
end

gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'bootsnap', require: false
