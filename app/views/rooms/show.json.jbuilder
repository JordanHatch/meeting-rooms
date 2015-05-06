json.room do
  json.short_title room_presenter.short_title
  json.title room_presenter.title
  json.custom_colour room_presenter.custom_colour

  json.schedule room_presenter.as_mustache_context(limit: params[:limit])[:schedule]
end
