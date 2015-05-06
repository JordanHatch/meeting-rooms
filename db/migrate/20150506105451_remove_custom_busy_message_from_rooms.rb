class RemoveCustomBusyMessageFromRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :custom_busy_message, :string
  end
end
