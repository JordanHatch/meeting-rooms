class EventImporter
  def initialize(room:)
    @room = room
  end

  def import
    events.each do |response|
      create_or_update_event(response)
    end
  end

private
  attr_reader :room

  def create_or_update_event(response)
    parsed_event = ApiFormattedEvent.build_from_response(response)

    event = room.events.find_or_initialize_by(source_id: parsed_event.source_id)
    event.assign_attributes(parsed_event.updateable_attributes)
    event.save
  end

  def events
    calendar_api.events(calendar_id: calendar_id)
  end

  def calendar_id
    room.calendar_id
  end

  def calendar_api
    MeetingRooms.services(:calendar_api)
  end
end
