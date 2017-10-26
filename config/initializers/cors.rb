# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*',
      headers: :any,
      expose:  %w[access-token expiry token-type uid client],
      methods: %i[get post put patch delete options]
  end
end
