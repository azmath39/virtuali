class ChangeColumnProductCategoryTour < ActiveRecord::Migration
  def change
    rename_column :tours, :category_id, :product_id
    add_column :products, :category_id, :integer
  end

  
end
