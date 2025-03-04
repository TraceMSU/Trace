# config/routes.rb
Rails.application.routes.draw do
  get '/search', to: 'search#search'
  get '/suggestions', to: 'suggestions#index'
  post '/import_products', to: 'import#import_products'
   # ... other routes if needed
end