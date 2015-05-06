json.url room_path(room, format: :json)
json.short_title room.short_title
json.title room.title
json.custom_colour room.custom_colour
json.status_message room.status_message
json.schedule room.as_mustache_context(limit: 3)[:schedule]
