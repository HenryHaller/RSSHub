class UserMailer < ApplicationMailer
  default from: 'notifications@rsshub.com'
  def please_authenticate
    @email = params[:email]
    @activation_token = params[:activation_token]
    @auth_url = "#{ENV['FRONTEND_URL']}/activate?" + {activation_token: @activation_token, email: @email}.to_param # token=#{@activation_token}&email=#{@email}"
    mail(to: @email, subject: "Please Activate your RSSHub Account")
  end
end