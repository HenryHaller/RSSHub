# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # POST /signup
  # return authenticated token upon signup
  skip_before_action :authorize_request, only: :create
  def create
    user = User.create!(user_params)
    UserMailer.with(email: user_params[:email], activation_token: user.activation_token).please_authenticate.deliver_now
    # auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created }
    json_response(response, :created)
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end

