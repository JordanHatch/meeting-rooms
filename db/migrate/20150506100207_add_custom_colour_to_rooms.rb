class AddCustomColourToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :custom_colour, :string
  end
end
