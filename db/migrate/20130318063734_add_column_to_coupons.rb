class AddColumnToCoupons < ActiveRecord::Migration
  def change
    rename_column :coupons, :valid, :valid_date
    add_column :coupons,:value, :float
  end
end
