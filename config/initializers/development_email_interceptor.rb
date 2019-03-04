if Rails.env.development? || Rails.env.test?
  # require "email_interceptor"
  # ActionMailer::Base.register_interceptor(EmailInterceptor)
  Rails.application.config.action_mailer.delivery_method = :test
end
