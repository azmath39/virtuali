class CreateSelectedPackages < ActiveRecord::Migration
  def change
    create_table :selected_packages do |t|
      t.integer :user_id
      t.integer :package_id
      t.float :price

      t.timestamps
    end
  end
end
