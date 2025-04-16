source "https://rubygems.org"

ruby "3.2.5"

gem 'rails', '7.1.2'
gem 'activesupport', '7.1.2'
gem 'neo4j-ruby-driver', '4.4.5'
gem 'i18n', '~> 1.14', '>= 1.14.7'
gem 'puma', '>= 6.6.0'
gem 'rack-cors'

group :development, :test do
  # if you want to stick with sqlite locally:
  gem 'sqlite3', '~> 1.4'
  gem 'debug', platforms: %i[mri windows]
+end

group :development do
  # gem "spring"
end

group :production do
  # the Heroku default Postgres adapter
  gem 'pg', '~> 1.4'
end

gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'bootsnap', require: false
