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

  def free_message
    custom_free_message.present? ? custom_free_message : "Available"
  end

  def events_with_gaps(limit: nil)
    list = current_and_future_events_today.inject([]) {|list, event|
      insert_gaps_for_event(list, event)
      list << event
    }
    insert_initial_gap(list)
    insert_end_of_day_gap(list)

    limit.present? ? list.first(limit.to_i) : list
  end

private
  def strip_leading_hash_from_custom_colour
    if custom_colour.present?
      custom_colour.sub!(/\A#/, '')
    end
  end

  def insert_gaps_for_event(list, event)
    return if list.blank?

    duration = event.start_at - list.last.end_at
    return if duration == 0

    list << create_gap(
      start_at: list.last.end_at,
      end_at: event.start_at,
    )
  end

  def insert_initial_gap(list)
    if list.any? && list.first.start_at > Time.now
      list.unshift create_gap(
        start_at: Time.now,
        end_at: list.first.start_at,
      )
    end
  end

  def insert_end_of_day_gap(list)
    start_at = list.any? ? list.last.end_at : Time.now

    list << create_gap(
      start_at: start_at,
      end_at: Time.now.end_of_day
    )
  end

  def create_gap(start_at:, end_at:)
    Gap.new(
      start_at: start_at,
      end_at: end_at,
      title: free_message,
    )
  end
end
