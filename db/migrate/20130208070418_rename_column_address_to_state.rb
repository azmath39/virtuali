class RenameColumnAddressToState < ActiveRecord::Migration
  def change
    rename_column :tours, :address, :state
  end

end
