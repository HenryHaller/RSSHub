require "episode_access_module"

class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :shows
  has_many :episodes, through: :shows
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :login_activities, as: :user # use :user no matter what your model name
  validates :email, presence: true
  validates :password, presence: true

  enum role: {
    user: 0,
    admin: 1
  }

  def already_subscribed?(rss_url)
    self.shows.any? { |show| show.rss_url == rss_url }
  end
end
