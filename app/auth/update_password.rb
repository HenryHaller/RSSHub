class UpdatePassword
  def initialize(email, new_password, current_password)
    @email = email
    @new_password = new_password
    @current_password = current_password
  end

  def call
    response
  end

  private

  attr_reader :email, :new_password, :current_password
  def response
    # puts current_password
    user = User.find_by(email: email)
    # Rails.logger.warn(email)
    # Rails.logger.warn(new_password)
    # Rails.logger.warn(current_password)
    # Rails.logger.warn(user)
    if user&.authenticate(current_password)
      user.password = new_password
      Rails.logger.warn(user.errors.messages) unless user.save
      { message: "Password Updated" }
    else
      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
  end
end