class ChangeLatitudeLongitudeColumnsPrecisionInTours < ActiveRecord::Migration
  def self.up
change_column :tours, :latitude, :decimal, :precision => 15, :scale => 12
    change_column :tours, :longitude, :decimal, :precision => 15, :scale => 12
  end

  def self.down
    change_column :tours, :latitude, :float
    change_column :tours, :longitude, :float
  end
end
