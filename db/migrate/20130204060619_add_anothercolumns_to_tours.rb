class AddAnothercolumnsToTours < ActiveRecord::Migration
  def change
    add_column :tours, :price, :float
    add_column :tours, :square_footage, :integer
    add_column :tours, :bed_rooms, :integer
    add_column :tours, :bath_rooms, :integer
    
  end
end
