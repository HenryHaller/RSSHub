class NewEpisodeMailer < ApplicationMailer
  default from: 'notifications@rsshub.com'
  def new_episode_email
    @user = params[:user]
    @episode = params[:episode]
    mail(to: @user.email, subject: 'New Episode')
  end
end
