class RoomsController < ApplicationController
  expose(:room, finder: :find_by_short_title)

  before_filter :authenticate!, only: [:new, :create, :edit, :update]

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

  def collection_dashboard
    render layout: 'dashboard'
  end

private
  def rooms_in_use
    build_presenters(Room.in_use)
  end
  helper_method :rooms_in_use

  def rooms_not_in_use
    build_presenters(Room.not_in_use)
  end
  helper_method :rooms_not_in_use

  def rooms
    build_presenters(Room.all)
  end
  helper_method :rooms

  def room_presenter(additional_options = {})
    RoomPresenter.new(room, options.merge(additional_options))
  end
  helper_method :room_presenter

  def build_presenters(rooms)
    RoomCollectionPresenter.new(rooms, options)
  end

  def room_params
    params.require(:room).permit(:title, :short_title, :calendar_id,
                            :custom_free_message, :custom_colour)
  end

  def options
    params.slice(:limit)
  end
end
