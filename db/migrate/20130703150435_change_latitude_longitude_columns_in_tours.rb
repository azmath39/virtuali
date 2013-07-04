class ChangeLatitudeLongitudeColumnsInTours < ActiveRecord::Migration
  def self.up
    change_column :tours, :latitude, :float, {:length => 15, :decimals => 12}
    change_column :tours, :longitude, :float, {:length => 15, :decimals => 12}

  end

  def self.down
    change_column :tours, :latitude, :float
    change_column :tours, :longitude, :float
  end
end
