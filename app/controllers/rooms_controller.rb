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

private
  def room_params
    params.require(:room).permit(:title, :short_title)
  end
end
