class Event < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :start_date, :end_date, :name, :description, :user, :location, presence: true
end
