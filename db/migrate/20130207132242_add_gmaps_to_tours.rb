class AddGmapsToTours < ActiveRecord::Migration
  def up
    add_column :tours, :gmaps, :boolean
  end
  def down
    remove_column :tours, :gmaps
  end
end
