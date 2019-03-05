# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  # return auth token once user is authenticated
  skip_before_action :authorize_request, only: %i[authenticate activate]
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token)
  end

  def activate
    auth_token = ActivateUser.new(auth_params[:email], auth_params[:activation_token]).call
    json_response(auth_token: auth_token)
  end

  private

  def auth_params
    params.permit(:email, :password, :activation_token)
  end
end