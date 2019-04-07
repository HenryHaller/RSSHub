# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  # return auth token once user is authenticated
  skip_before_action :authorize_request, only: %i[authenticate activate password_recovery_attempt password_recovery_request log_out, check_login]
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    session[:access_token] = auth_token
    json_response(nil)
  end

  def check_login
    if session[:access_token] == nil
      json_response({message: Message.missing_token}, 200)
    else
      decoded_auth_token = JsonWebToken.decode(session[:access_token])
      if decoded_auth_token.key?(:user_id)
        begin
          user = User.find(decoded_auth_token[:user_id])
          json_response(nil, 204)
        rescue
          json_response({message: "User not found."}, 200)
        end
      else
        json_response({message: "No user id in access token"}, 200)
      end
    end
  end

  def activate
    auth_token = ActivateUser.new(auth_params[:email], auth_params[:activation_token]).call
    session[:access_token] = auth_token
    json_response(nil)
  end

  def password_recovery_request
    PasswordRecoveryRequest.new(auth_params[:email]).call
    json_response(nil, 204)
  end

  def password_recovery_attempt
    PasswordRecoveryAttempt.new(auth_params[:email], auth_params[:recovery_token], auth_params[:new_password]).call
    json_response(nil, 204)
  end

  def update_password
    UpdatePassword.new(current_user, auth_params[:new_password], auth_params[:current_password]).call
    json_response(nil, 204)
  end

  def log_out
    reset_session
    json_response(nil, 204)
  end

  private

  def auth_params
    params.permit(:email, :password, :activation_token, :recovery_token, :new_password, :current_password)
  end
end