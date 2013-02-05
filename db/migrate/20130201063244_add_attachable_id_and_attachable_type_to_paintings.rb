class AddAttachableIdAndAttachableTypeToPaintings < ActiveRecord::Migration
  def change
    add_column :paintings, :attachable_id, :integer
    add_column :paintings, :attachable_type, :string
  end
end
