class PasswordRecoveryAttempt
  def initialize(email, recovery_token, new_password)
    @email = email
    @recovery_token = recovery_token
    @new_password = new_password
  end
  
  def call
    response
  end
  
  private

  attr_reader :email, :recovery_token, :new_password
  
  def response
    user = User.find_by(email: email)
    if user && user.check_reset_token(recovery_token)
      user.password = new_password
      Rails.logger.warn(user.errors.messages) unless user.save
    else
      raise(ExceptionHandler::InvalidRecoveryTokenError, Message.invalid_recovery_token)
    end
  end
end