require 'delegate'

class EventPresenter < SimpleDelegator

  def as_json
    {
      title: title,
      start_at: format_time(event.start_at),
      end_at: format_time(event.end_at),
    }
  end

  def title
    if event.private?
      "Private event"
    else
      event.title
    end
  end

private
  include TimeHelper

  def event
    __getobj__
  end

end
