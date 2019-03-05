class ActivateUser
  def initialize(email, activation_token)
    @email = email
    @activation_token = activation_token
  end

  def call
    puts "calling activate_user service"
    user = activate
    JsonWebToken.encode(user_id: user.id, user_email: user.email) if user
  end

  private

  attr_reader :email, :activation_token

  def activate
    puts "calling user function"
    user = User.find_by(email: email)
    raise(ExceptionHandler::AlreadyActivatedError, Message.account_already_activated) if user.activated?

    if user.check_activation_token(activation_token)
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      return user
    else
      raise ActivationError
    end
  end
end