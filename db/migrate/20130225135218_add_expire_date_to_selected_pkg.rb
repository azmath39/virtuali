class AddExpireDateToSelectedPkg < ActiveRecord::Migration
  def change
    add_column :selected_packages,:expire_date, :date
  end
end
