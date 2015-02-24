json.room do
  json.short_title presented_room.short_title
  json.title presented_room.title

  json.schedule presented_room.events_with_gaps do |event|
    json.title event.title
    json.start_at event.start_at
    json.end_at event.end_at
  end
end
