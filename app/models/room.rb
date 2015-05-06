class Room < ActiveRecord::Base
  has_many :events
  has_many :current_events, -> { current }, class_name: 'Event'

  validates :title, :short_title, :calendar_id, presence: true
  validates :short_title, uniqueness: true,
                          length: { maximum: 4 },
                          format: { with: /\A[^ ]+\z/ }

  scope :in_use, -> { joins(:current_events) }
  scope :not_in_use, -> { where.not(id: in_use) }

  def in_use?
    current_events.any?
  end

  def current_and_future_events_today
    current_events + events.future.today
  end

  def to_param
    short_title
  end
end
