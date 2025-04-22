# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # in dev, allow any origin so you can test from localhost:<your port>
    if Rails.env.development?
      origins '*'
    else
      # in production, only allow your actual API host
      origins 'https://tracetest-dc00a8c7f59d.herokuapp.com'
    end

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      max_age: 600
  end
end
