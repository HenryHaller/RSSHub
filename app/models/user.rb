require "episode_access_module"

class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :shows
  has_many :episodes, through: :shows

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :login_activities, as: :user # use :user no matter what your model name
  validates :email, presence: true
  # validates :password, presence: true

  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token

  enum role: {
  user: 0,
  admin: 1
}


def already_subscribed?(rss_url)
  self.shows.any? { |show| show.rss_url == rss_url }
end


def activated?
  activated
end

def check_activation_token(activation_token)
  BCrypt::Password.new(activation_digest).is_password?(activation_token)
end

def check_reset_token(reset_token)
  BCrypt::Password.new(reset_digest).is_password?(reset_token)
end

# Returns the hash digest of the given string.
def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
  BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
end

# Returns a random token.
def User.new_token
  SecureRandom.urlsafe_base64
end

def send_password_reset_email(reset_token)
  UserMailer.with(reset_token: reset_token, email: self.email).password_reset.deliver_now
end

def create_reset_token
  reset_token = User.new_token
  self.reset_digest = User.digest(reset_token)
  puts self.errors.messages unless self.save
  reset_token
end

private
def create_activation_digest
  self.activation_token  = User.new_token
  self.activation_digest = User.digest(activation_token)
end
end
