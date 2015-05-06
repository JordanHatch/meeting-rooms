class RoomCollectionPresenter
  include Enumerable

  def initialize(rooms, options = {})
    @rooms = rooms
    @options = options
  end

  def each(&block)
    presented_rooms.each do |room|
      block.call(room)
    end
  end

  def as_json
    {
      rooms: presented_rooms.map(&:as_json)
    }
  end

private
  attr_reader :rooms, :options

  def presented_rooms
    rooms.map {|room|
      RoomPresenter.new(room, options)
    }
  end
end
