class ChangeColumnNamesOfPackages < ActiveRecord::Migration
  def change
     rename_column :packages, :monthly_price, :regular_price
     rename_column :packages, :yearly_price, :special_price
  end
end
