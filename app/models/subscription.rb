class Subscription < ApplicationRecord
  belongs_to :user
  validates :endpoint, presence: true
  validates :endpoint, uniqueness: true

  def push(data)
    begin
    Webpush.payload_send( endpoint: self.endpoint, p256dh: self.p256dh, auth: self.auth, message: JSON.generate(data), api_key: ENV["GCM_SERVER_KEY"])
    rescue Webpush::ExpiredSubscription => e
      # Rails.logger.warn(e.message)
      Rails.logger.warn("Expired Endpoint discovered, self destructing")
      self.destroy
    end
  end
end
