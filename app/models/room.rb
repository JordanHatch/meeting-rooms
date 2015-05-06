class Room < ActiveRecord::Base
  has_many :events
  has_many :current_events, -> { current }, class_name: 'Event'

  validates :title, :short_title, :calendar_id, presence: true
  validates :short_title, uniqueness: true,
                          length: { maximum: 4 },
                          format: { with: /\A[^ ]+\z/ }
  validates :custom_colour, length: { maximum: 6 },
                            format: { with: /\A[A-Za-z0-9]+\z/, allow_blank: true }

  scope :in_use, -> { joins(:current_events) }
  scope :not_in_use, -> { where.not(id: in_use) }

  before_validation :strip_leading_hash_from_custom_colour

  def in_use?
    current_events.any?
  end

  def current_and_future_events_today
    current_events + events.future.today
  end

  def to_param
    short_title
  end

private
  def strip_leading_hash_from_custom_colour
    if custom_colour.present?
      custom_colour.sub!(/\A#/, '')
    end
  end
end
