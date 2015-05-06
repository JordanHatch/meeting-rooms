require 'delegate'

class RoomPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  def initialize(instance, options = {})
    @options = options
    super(instance)
  end

  def as_json
    {
      url: room_path(room),
      short_title: room.short_title,
      title: room.title,
      custom_colour: room.custom_colour,
      status: {
        value: status,
        message: status_message,
      },
      schedule: room.events_with_gaps(limit: event_limit).map {|event|
        EventPresenter.new(event).as_json
      }
    }
  end

  def status
    first_event.status
  end

  def status_message
    first_event.title
  end

private
  include TimeHelper

  attr_reader :options

  def event_limit
    options.fetch(:limit, nil)
  end

  def first_event
    events_with_gaps.first
  end

  def room
    __getobj__
  end

end
