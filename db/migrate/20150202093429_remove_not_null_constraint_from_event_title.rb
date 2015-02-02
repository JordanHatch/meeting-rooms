class RemoveNotNullConstraintFromEventTitle < ActiveRecord::Migration
  def change
    change_column :events, :title, :string, null: true
  end
end
