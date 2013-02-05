class AddColumnsToTours < ActiveRecord::Migration
  def change
    add_column :tours, :city, :string
    add_column :tours, :zip, :string
    add_column :tours, :subdivision, :string
  end
end
