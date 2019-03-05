class UserMailer < ApplicationMailer
  default from: 'notifications@rsshub.com'
  def please_authenticate
    @email = params[:email]
    @activation_token = params[:activation_token]
    @auth_url = "#{ENV['FRONTEND_URL']}/activate?" + {activation_token: @activation_token, email: @email}.to_param # token=#{@activation_token}&email=#{@email}"
    mail(to: @email, subject: "Please Activate your RSSHub Account")
  end

  def password_reset
    @reset_token = params[:reset_token]
    @email = params[:email]
    @recovery_link = "#{ENV['FRONTEND_URL']}/recover?" + {reset_token: @reset_token, email: @email}.to_param
    mail to: @email, subject: "Password Reset"
  end
end