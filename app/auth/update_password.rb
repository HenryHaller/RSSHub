class UpdatePassword
  def initialize(user, new_password, current_password)
    @user = user
    @new_password = new_password
    @current_password = current_password
  end

  def call
    response
  end

  private

  attr_reader :user, :new_password, :current_password
  def response
    # puts current_password
    # user = User.find_by(email: email)
    # Rails.logger.warn(email)
    # Rails.logger.warn(new_password)
    # Rails.logger.warn(current_password)
    # Rails.logger.warn(user)
    if user.authenticate(current_password)
      user.password = new_password
      Rails.logger.error(user.errors.messages) unless user.save
    else
      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
  end
end