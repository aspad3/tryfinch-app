email_setting = {
  address: ENV["SMTP_ADDRESS"],
  port: ENV["SMTP_PORT"],
  domain: ENV["SMTP_DOMAIN"],
  user_name: ENV["SMTP_USER_NAME"],
  password: ENV["SMTP_PASSWORD"],
  smtp_default_from: ENV["SMTP_DEFAULT_FROM"],
  enable_starttls_auto: true
}

Rails.application.config.action_mailer.default_url_options = {:host => ENV["HOST"] }
Rails.application.config.action_mailer.smtp_settings = email_setting
ActionMailer::Base.delivery_method = Rails.env.production? ? :smtp : :letter_opener
Rails.application.config.action_mailer.perform_deliveries = true
Rails.application.config.action_mailer.raise_delivery_errors = true