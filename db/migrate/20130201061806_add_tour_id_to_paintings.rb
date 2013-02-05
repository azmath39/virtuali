class AddTourIdToPaintings < ActiveRecord::Migration
  def change
    add_column :paintings, :tour_id, :integer
  end
end
