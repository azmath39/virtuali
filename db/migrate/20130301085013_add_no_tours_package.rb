class AddNoToursPackage < ActiveRecord::Migration
  def change
    add_column :packages, :no_of_tours, :integer
  end

  
end
