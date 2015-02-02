class EventImporter
  def initialize(room:)
    @room = room
  end

  def import
    events.each do |event|
      create_or_update_event(event)
    end

    delete_events_not_present_in_import
  end

private
  attr_reader :room

  def create_or_update_event(event)
    return if event.declined?

    new_event = room.events.find_or_initialize_by(source_id: event.source_id)
    new_event.assign_attributes(event.updateable_attributes)
    new_event.save
  end

  def delete_events_not_present_in_import
    existing_events_not_present_in_import.delete_all
  end

  def existing_events_not_present_in_import
    room.events.where.not(source_id: imported_source_ids)
  end

  def events
    events_from_api.map {|response|
      ApiFormattedEvent.new(response)
    }
  end

  def imported_source_ids
    events.map(&:source_id)
  end

  def events_from_api
    @events_from_api ||= calendar_api.events(calendar_id: calendar_id)
  end

  def calendar_id
    room.calendar_id
  end

  def calendar_api
    MeetingRooms.services(:calendar_api)
  end
end
