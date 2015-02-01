module ApplicationHelper
  def app_title
    ENV['APP_TITLE'] || 'Meeting Rooms'
  end
end
