class AddOrderNumberToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :order_number, :string
  end
end
