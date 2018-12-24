require "EpisodeAccessModule"

class User < ApplicationRecord
  include EpisodeAccessModule
  has_and_belongs_to_many :shows
  has_many :episodes, through: :shows
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable


  enum role: {
    user: 0,
    admin: 1
  }

  def already_subscribed?(rss_url)
    self.shows.any? { |show| show.rss_url == rss_url }
  end
end
