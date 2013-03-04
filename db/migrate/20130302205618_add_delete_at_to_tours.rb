class AddDeleteAtToTours < ActiveRecord::Migration
  def change
    add_column :tours, :deleted_at, :datetime
  end
end
