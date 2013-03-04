class AddPricePerMonthAndYear < ActiveRecord::Migration
  def change
    remove_column :packages,:description
    remove_column :packages, :price
    add_column :packages,:monthly_price, :float
    add_column :packages, :yearly_price, :float
  end

  
end
