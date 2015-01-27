module MeetingRooms
  def self.services(name, service = nil)
    @services ||= {}

    if service
      @services[name] = service
      return true
    else
      if @services[name]
        return @services[name]
      else
        raise ServiceNotRegisteredException.new(name)
      end
    end
  end

  class ServiceNotRegisteredException < Exception; end
end

MeetingRooms.services(:calendar_api, CalendarApi.new(
  issuer: ENV['CALENDAR_API_ISSUER'],
  signing_key: ENV['CALENDAR_API_SIGNING_KEY']
))
