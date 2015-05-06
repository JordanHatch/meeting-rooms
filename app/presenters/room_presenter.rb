require 'delegate'

class RoomPresenter < SimpleDelegator

  def as_mustache_context(limit: nil)
    {
      schedule: events_with_gaps(limit: limit).map {|event|
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

end
