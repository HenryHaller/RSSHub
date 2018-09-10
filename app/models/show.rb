class Show < ApplicationRecord
  has_many :episodes
  has_and_belongs_to_many :users
end
