json.room do
  json.short_title room_presenter.short_title
  json.title room_presenter.title

  json.schedule room_presenter.events_with_gaps do |event|
    json.title event.title
    json.start_at event.start_at
    json.end_at event.end_at
  end
end
