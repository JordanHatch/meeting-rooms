require 'delegate'

class RoomPresenter < SimpleDelegator

  def events_with_gaps
    list = room.current_and_future_events.inject([]) {|list, event|
      insert_gaps_for_event(list, event)
      list << event
    }
    insert_initial_gap(list)
    insert_end_of_day_gap(list)

    list
  end

  # TODO: can this be simplified to:
  #
  # - return both formatted and full timestamps in a nested object
  #
  def as_mustache_context
    {
      schedule: events_with_gaps.map {|event|
        EventPresenter.new(event).as_json
      }
    }
  end

  def status_message
    if room.in_use?
      busy_message
    else
      free_message
    end
  end

  def free_message
    custom_free_message.present? ? custom_free_message : "Available"
  end

  def busy_message
    custom_busy_message.present? ? custom_busy_message : "In use"
  end

private
  include TimeHelper

  def room
    __getobj__
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
