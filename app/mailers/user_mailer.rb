class UserMailer < ApplicationMailer
  default from: 'notifications@rsshub.com'
  def please_authenticate
    @email = params[:email]
    @token = params[:token]
    @auth_url = "#{ENV['FRONTEND_URL']}/authenticate?token=#{@token}"
    mail(to: @email, subject: "Please Authenticate with RSSHub.")
  end
end