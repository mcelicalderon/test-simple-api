class Event < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :start_date, :end_date, :name, :description,
            :user, :location, presence: true

  def duration
    (end_date - start_date).to_i
  end

  def duration=(duration)
    return if [self.start_date, self.end_date].all? { |date| date.present? }
    return if [self.start_date, self.end_date].all? { |date| date.blank? }

    if self.start_date.present?
      self.end_date = self.start_date + duration
    elsif self.end_date.present?
      self.start_date = self.end_date - duration
    end
  end
end
