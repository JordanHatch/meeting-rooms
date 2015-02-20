require 'delegate'

class RoomPresenter < SimpleDelegator

  def events_with_gaps
    list = room.current_and_future_events.inject([]) {|list, event|
      insert_gaps_for_event(list, event)
      list << event
    }
    insert_initial_gap(list)

    list
  end

private

  def room
    __getobj__
  end

  def insert_gaps_for_event(list, event)
    return if list.blank?

    duration = event.start_at - list.last.end_at
    return if duration == 0

    list << Gap.new(
      start_at: list.last.end_at,
      end_at: event.start_at
    )
  end

  def insert_initial_gap(list)
    unless list.any? && list.first.start_at > Time.now
      return
    end

    list.unshift Gap.new(
      start_at: Time.now,
      end_at: list.first.start_at,
    )
  end

end
