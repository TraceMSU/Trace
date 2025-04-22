# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # always allow your production API host
    allowed = ['https://tracetest-dc00a8c7f59d.herokuapp.com']
    # plus any extra origins you list in ENV
    allowed.concat((ENV['CORS_ORIGINS'] || '').split(','))

    origins(*allowed)

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      max_age: 600
  end
end
