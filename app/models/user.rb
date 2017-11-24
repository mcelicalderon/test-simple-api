class User < ApplicationRecord
  has_many :events

  validates :first_name, :last_name, presence: true
end
