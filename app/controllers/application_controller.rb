# skip_before_action :verify_authenticity_token
class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authorize_request
    authorize = AuthorizeApiRequest.new(request.headers).call
    @current_user = authorize[:user]
  end
end
