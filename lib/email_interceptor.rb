class EmailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = ['henrybhaller@gmail.com']
  end
end
