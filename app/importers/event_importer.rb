class EventImporter
  def initialize(calendar_id:, room_id:)
    @calendar_id = calendar_id
    @room_id = room_id
  end

  def import
    events.each do |response|
      event = ApiFormattedEvent.build_from_response(response).to_event_instance
      event.room_id = room_id
      event.save
    end
  end

private
  attr_reader :calendar_id, :room_id

  def events
    calendar_api.events(calendar_id: calendar_id)
  end

  def calendar_api
    MeetingRooms.services(:calendar_api)
  end
end
