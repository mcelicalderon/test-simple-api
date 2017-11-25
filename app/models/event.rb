class Event < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :location, optional: true

  state_machine initial: :draft do
    state :published do
      validates :start_date, :end_date, :name, :description,
                :user, :location, presence: true
    end

    event :publish do
      transition draft: :published
    end

    event :unpublish do
      transition published: :draft
    end

    event :remove do
      transition any => :deleted
    end
  end

  def duration
    return unless [end_date, start_date].all? { |date| date.present? }
    (end_date - start_date).to_i
  end

  def duration=(duration)
    # Behavior could change, depending on what the user wants
    # duration could override one of the two values if they are both present
    return if start_and_end_present? || start_and_end_absent?

    duration = Integer(duration)
    if self.start_date.present?
      self.end_date = self.start_date + duration
    elsif self.end_date.present?
      self.start_date = self.end_date - duration
    end
  end

  def as_json(options = { })
    super(options).merge(duration: duration)
  end

  private

  def start_and_end_present?
    [self.start_date, self.end_date].all? { |date| date.present? }
  end

  def start_and_end_absent?
    [self.start_date, self.end_date].all? { |date| date.blank? }
  end
end
