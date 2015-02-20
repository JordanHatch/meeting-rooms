class RoomsController < ApplicationController
  expose(:rooms)
  expose(:room)

  def create
    room.attributes = room_params
    if room.save
      flash.notice = 'Room created'
      redirect_to rooms_path
    else
      render action: :new
    end
  end

  def update
    if room.update_attributes(room_params)
      flash.notice = 'Room saved'
      redirect_to room_path(room)
    else
      render action: :edit
    end
  end

  def import
    importer = EventImporter.new(room: room)
    importer.import

    flash.notice = 'Import complete'
    redirect_to room_path
  end

  def import_all
    importer = BulkEventImporter.new
    importer.import

    flash.notice = 'Import complete'
    redirect_to rooms_path
  end

  def dashboard
    render layout: 'dashboard'
  end

private
  def presented_room
    RoomPresenter.new(room)
  end
  helper_method :presented_room

  def rooms_in_use
    Room.in_use
  end
  helper_method :rooms_in_use

  def rooms_not_in_use
    Room.not_in_use
  end
  helper_method :rooms_not_in_use

  def room_params
    params.require(:room).permit(:title, :short_title, :calendar_id)
  end
end
