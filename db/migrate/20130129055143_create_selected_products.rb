class CreateSelectedProducts < ActiveRecord::Migration
  def change
    create_table :selected_products do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
  end
end
