class RoomsController < ApplicationController
  expose(:rooms)
  expose(:room, attributes: :room_params)

  def create
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

private
  def room_params
    params.require(:room).permit(:title, :short_title)
  end
end
