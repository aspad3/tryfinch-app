class ApplicationMailer < ActionMailer::Base
  default from: "tryfinch-demo <#{ENV.fetch('SMTP_DEFAULT_FROM', nil)}>"
  layout 'mailer'
end
