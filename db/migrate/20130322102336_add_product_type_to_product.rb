class AddProductTypeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_type, :integer
  end
end
