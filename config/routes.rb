Rails.application.routes.draw do
  get '/ping', to: proc { [200, {}, ['pong']] }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Search endpoint
  get '/search', to: 'search#search'

  # Suggestions endpoint
  get '/suggestions', to: 'suggestions#index'

  # Product import endpoint (POST with file param)
  post '/import_products', to: 'import#import_products'

  #search product
  get '/products/search/', to: 'products#search'
end
