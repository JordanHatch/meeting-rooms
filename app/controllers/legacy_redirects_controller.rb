class LegacyRedirectsController < ApplicationController

  def room_dashboard
    redirect_to dashboard_room_path(params[:id])
  end

end
