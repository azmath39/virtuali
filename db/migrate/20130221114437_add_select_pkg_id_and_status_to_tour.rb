class AddSelectPkgIdAndStatusToTour < ActiveRecord::Migration
  def change
    remove_column :tours, :status
    add_column :tours,:status,:integer
    add_column :tours, :selected_package_id, :integer
  end
end
