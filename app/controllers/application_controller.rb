class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # protect_from_forgery with: :exception
  # before_action :authenticate_user!
  # def after_sign_in_path_for(resource_or_scope)
  #   shows_path
  # end
end
