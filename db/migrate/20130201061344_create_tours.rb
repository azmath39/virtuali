class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :name
      t.string :address
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
