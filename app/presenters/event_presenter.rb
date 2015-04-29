require 'delegate'

class EventPresenter < SimpleDelegator

  def as_json
    {
      title: title,
      start_at: {
        formatted: formatted_start_at,
        timestamp: event.start_at,
      },
      end_at: {
        formatted: formatted_end_at,
        timestamp: event.end_at,
      },
    }
  end

  def title
    if event.private?
      "Private event"
    else
      event.title
    end
  end

  def formatted_start_at
    if event.start_at.change(sec: 0) == Time.now.change(sec: 0)
      "Now"
    else
      format_time(event.start_at)
    end
  end

  def formatted_end_at
    if event.end_at == event.end_at.end_of_day
      "Until the end of the day"
    else
      format_time(event.end_at)
    end
  end

private
  include TimeHelper

  def event
    __getobj__
  end

end
