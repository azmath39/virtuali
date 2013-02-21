class AddStatusTo < ActiveRecord::Migration
  def up
    add_column :selected_packages, :status, :integer
  end

  def down
    remove_column :selected_packages, :status
  end
end
