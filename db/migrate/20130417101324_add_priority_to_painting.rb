class AddPriorityToPainting < ActiveRecord::Migration
  def change
    add_column :paintings, :priority, :integer
  end
end
