class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :logo
      t.integer :user_id

      t.timestamps
    end
  end
end
