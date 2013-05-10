 class AddLatitudeAndLongitudeToTours < ActiveRecord::Migration
  def up
    add_column :tours, :latitude, :float
    add_column :tours, :longitude, :float
  end
  def down
    remove_column :tours, :latitude
    remove_column :tours, :longitude
  end
end
