class AddDraftIdToPaintings < ActiveRecord::Migration
  def change
    add_column :paintings, :draft_id, :integer
  end
end
