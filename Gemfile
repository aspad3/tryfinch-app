source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "dotenv"
gem "faker"
gem "tryfinch-api", "0.0.1", path: "../tryfinch-api"
gem 'devise'

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
  gem "rubocop", "~> 1.72"
  gem "rubocop-rails", "~> 2.30"
  gem "rubocop-performance", "~> 1.24"
  gem "rubocop-rspec", "~> 3.5"
  gem "letter_opener"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Opsional
# gem "redis", ">= 4.0.1"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"
# gem "rack-mini-profiler"
# gem "spring"
