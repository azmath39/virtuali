class AddAddressToTours < ActiveRecord::Migration
  def change
    add_column :tours, :address, :text
  end
end
