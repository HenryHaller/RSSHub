module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ActivationError < StandardError; end
  class AlreadyActivatedError < StandardError; end
  class InvalidRecoveryTokenError < StandardError; end
  class InactiveUser < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::ActivationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AlreadyActivatedError, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidRecoveryTokenError, with: :unauthorized_request
    rescue_from ExceptionHandler::InactiveUser, with: :four_twenty_two
    # rescue_from HTTP::Request::UnsupportedSchemeError, with: :four_twenty_two
    # rescue_from ExceptionHandler::RecordNotUnique, with: :account_already_exists
    rescue_from PG::UniqueViolation, with: :account_already_exists

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  def account_already_exists(err)
    if Rails.env == "development"
      four_twenty_two(err)
    else
      json_response({ message: "Duplicate Key" }, :unprocessable_entity)
    end
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(err)
    Rails.logger.warn(err)
    json_response({ message: err.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(err)
    Rails.logger.warn(err)
    json_response({ message: err.message }, :unauthorized)
  end
end
