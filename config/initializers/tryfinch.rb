# config/initializers/tryfinch.rb (inside the Rails app using the gem)
Tryfinch::API::Config.configure do |config|
  config.client_id = ENV["TRYFINCH_CLIENT_ID"]
  config.client_secret = ENV["TRYFINCH_CLIENT_SECRET"]
  config.products = ENV["TRYFINCH_PRODUCTS"]&.split(",") || []
  config.redirect_uri = ENV["TRYFINCH_REDIRECT_URI"]
  config.sandbox_env = ENV["TRYFINCH_SANDBOX_ENV"]
end
