class ApiFormattedEvent

  def initialize(attributes)
    @attributes = attributes
  end

  def self.build_from_response(response)
    self.new attributes_from_hash(response.to_hash)
  end

  def updateable_attributes
    attributes.except(:source_id)
  end

  def source_id
    attributes[:source_id]
  end

  attr_reader :attributes

private

  def self.attributes_from_hash(hash)
    {
      source_id: hash['id'],
      title: hash['summary'],
      creator: hash['creator']['displayName'],
      start_at: format_time(hash['start']),
      end_at: format_time(hash['end']),
    }
  end

  def self.format_time(time_hash)
    if time_hash['dateTime'].present?
      Time.parse(time_hash['dateTime'])
    elsif time_hash['date'].present?
      Time.parse(time_hash['date'])
    end
  end

end
