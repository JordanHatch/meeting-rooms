require 'delegate'

class EventPresenter < SimpleDelegator

  def as_json
    {
      title: event.title,
      start_at: format_time(event.start_at),
      end_at: format_time(event.end_at),
    }
  end

private
  include TimeHelper

  def event
    __getobj__
  end

end
