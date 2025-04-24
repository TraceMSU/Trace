source "https://rubygems.org"

ruby "3.4.2"
gem 'csv'
gem 'logger'      # brings in stdlib Logger
gem 'bigdecimal'  # brings in stdlib BigDecimal
gem 'benchmark'
gem 'rdoc', require: false
gem 'rails', '~> 7.0.6'


gem 'neo4j', '~> 9.6.2'        # provides ActiveNode
gem 'neo4j-ruby-driver', '4.4.5' # the low‑level driver
gem 'activegraph', '~> 10.0'
gem 'roo-xls'

gem 'i18n', '~> 1.14', '>= 1.14.7'
gem 'puma', '>= 6.6.0'
gem 'rack-cors'
gem 'openfoodfacts'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'debug', platforms: %i[mri windows]
end

group :production do
  gem 'pg', '~> 1.4'
end

gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'bootsnap', require: false
