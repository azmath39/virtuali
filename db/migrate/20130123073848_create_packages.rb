class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.float :price
      t.integer :product_id
      t.integer :pictures_for_tour
      t.integer :status

      t.timestamps
    end
  end
end
