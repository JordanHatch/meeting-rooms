class AddCustomAvailabilityMessagesToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :custom_free_message, :string
    add_column :rooms, :custom_busy_message, :string
  end
end
