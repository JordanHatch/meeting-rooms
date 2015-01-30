class AddCalendarIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :calendar_id, :string
  end
end
