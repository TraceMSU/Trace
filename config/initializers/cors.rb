# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # always allow your production host
    allowed = ['https://tracetest-dc00a8c7f59d.herokuapp.com']
    # you can still inject more via ENV if you like…
    allowed.concat((ENV['CORS_ORIGINS'] || '').split(','))

    # also allow any localhost on any port
    origins(*allowed, /\Ahttp:\/\/localhost:\d+\z/)

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      max_age: 600
  end
end
