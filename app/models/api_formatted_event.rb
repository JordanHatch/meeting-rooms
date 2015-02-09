class ApiFormattedEvent

  def initialize(response)
    @response = response
  end

  def attributes
    {
      source_id: response['id'],
      title: response['summary'],
      creator: creator,
      start_at: format_time(response['start']),
      end_at: format_time(response['end']),
    }
  end

  def updateable_attributes
    attributes.except(:source_id)
  end

  def source_id
    attributes[:source_id]
  end

  def declined?
    calendar_attendee &&
      calendar_attendee['responseStatus'] == 'declined'
  end

private

  attr_reader :response

  # Expects an instance of Google::APIClient::Schema::Calendar::V3::EventDateTime
  #
  def format_time(event_date_time)
    hash = event_date_time.to_hash

    if hash['dateTime'].present?
      Time.parse(hash['dateTime'])
    elsif hash['date'].present?
      Time.parse(hash['date'])
    end
  end

  def calendar_attendee
    attendees.find {|attendee|
      attendee['self'] == true
    }
  end

  def attendees
    response['attendees'] || []
  end

  def creator
    if (details = response['creator'])
      details['displayName']
    end
  end

end
