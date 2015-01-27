class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title, null: false
      t.string :short_title, null: false
      t.timestamps null: false
    end
  end
end
