class AddOrderNumberToTours < ActiveRecord::Migration
  def change
    add_column :tours, :order_number, :string
  end
end
