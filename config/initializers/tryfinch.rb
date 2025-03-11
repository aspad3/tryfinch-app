# config/initializers/tryfinch.rb (inside the Rails app using the gem)
Tryfinch::API::Config.configure do |config|
  config.client_id = ENV.fetch('TRYFINCH_CLIENT_ID', nil)
  config.client_secret = ENV.fetch('TRYFINCH_CLIENT_SECRET', nil)
  config.products = ENV['TRYFINCH_PRODUCTS']&.split(',') || []
  config.redirect_uri = ENV.fetch('TRYFINCH_REDIRECT_URI', nil)
  config.sandbox_env = ENV.fetch('TRYFINCH_SANDBOX_ENV', nil)
end
