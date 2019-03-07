# app/auth/authenticate_user.rb
class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Service entry point
  def call
    user = authenticate
    JsonWebToken.encode(user_id: user.id, user_email: user.email) if user
  end

  private

  attr_reader :email, :password

  # verify user credentials
  def authenticate
    user = User.find_by(email: email)
    raise(ExceptionHandler::InactiveUser, Message.inactive_user) if user && !user.activated?
    return user if user&.authenticate(password)

    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
