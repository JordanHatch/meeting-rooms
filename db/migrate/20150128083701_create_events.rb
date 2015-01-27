class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :source_id, null: false
      t.integer :room_id, null: false
      t.string :title, null: false
      t.string :creator
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps null: false
    end
  end
end
