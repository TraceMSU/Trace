# config/routes.rb
Rails.application.routes.draw do
  get '/search', to: 'search#search' # Define the search route
end
Rails.application.routes.draw do
  # ... other routes
  post '/import_products', to: 'import#import_products' # For importing products
end