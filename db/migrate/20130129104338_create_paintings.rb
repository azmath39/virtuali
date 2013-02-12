class CreatePaintings < ActiveRecord::Migration
  def change
    create_table :paintings do |t|
      t.string :name
      t.string :image
      

      t.timestamps
    end
   # add_index :paintings, :attachable_id
  end
end
