# skip_before_action :verify_authenticity_token
class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include CustomSerializers
  include UrlFixer

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    if session[:access_token] == nil
      json_response({ message: Message.missing_token }, 401)
    else
      authorize = AuthorizeApiRequest.new(session[:access_token]).call
      @current_user = authorize[:user]
    end
  end
end
