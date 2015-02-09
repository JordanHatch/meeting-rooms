class BulkEventImporter

  def import
    rooms.each {|room|
      EventImporter.new(room: room).import
    }
  end

private

  def rooms
    Room.all
  end

end
