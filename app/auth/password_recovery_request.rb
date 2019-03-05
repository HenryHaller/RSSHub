class PasswordRecoveryRequest
  def initialize(email)
    @email = email
  end
  
  def call
    response
  end
  
  private

  attr_reader :email
  
  def response
    user = User.find_by(email: email)
    if user
      reset_token = user.create_reset_token
      user.send_password_reset_email(reset_token)
      {message: "Password Recovery Email Sent"}
    else
      raise InvalidRecord
    end
  end
end