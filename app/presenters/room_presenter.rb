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
    events_with_gaps.first.title
  end

private
  include TimeHelper

  def room
    __getobj__
  end

end
