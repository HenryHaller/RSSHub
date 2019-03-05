class UpdatePassword
  def initialize(email, new_password)
    @email = email
    @new_password = new_password
  end

  def call
    response
  end

  private

  attr_reader :email, :new_password
  def response
    user = User.find_by(email: email)
    if user
      user.password = new_password
      puts user.errors.messages unless user.save
      {message: "Password Updated"}
    else
      raise InvalidRecord
    end
  end
end