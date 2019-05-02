class Episode < ApplicationRecord
  belongs_to :show, touch: true
  validates :title, presence: true
  validates :title, uniqueness: { scope: :show }

  def as_json(options)
    json = super
    json["show_title"] = show.title
    json["show_img"] = show.show_img
    json
  end

  def notification
    notification = {}
    notification["title"] = "New Episode of #{self.show.title}"
    notification["body"] = "#{self.title}"
    notification["loc"] = "show/#{self.show.id}"
    # notification["loc"] = "episodes"
    notification["icon"] = './img/icons/android-chrome-192x192.png'
    notification["actions"] = [{ action: 'go', title: 'See new Episode!' }]
    notification
  end

  def update_subscribers
    self.show.notification_subscriptions.where(subscribed: true).each do |su|
      su.user.subscriptions.each { |subscription| subscription.push(notification)}
    end
  end

  def safe_title
    t = title
    t.tr!("'", "")
    t.tr!('"', "")
    t.tr!('(', '')
    t.tr!(')', '')
    t.tr!('/', ' ')
    t.tr!(' ', '_')
    t
  end
end
