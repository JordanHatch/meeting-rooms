json.rooms do
  json.not_in_use rooms_not_in_use, partial: 'rooms/room', as: :room
  json.in_use rooms_in_use, partial: 'rooms/room', as: :room
end
