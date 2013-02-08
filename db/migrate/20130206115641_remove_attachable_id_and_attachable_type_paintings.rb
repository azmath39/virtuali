class RemoveAttachableIdAndAttachableTypePaintings < ActiveRecord::Migration
  def change
    remove_column :paintings, :attachable_id
    remove_column :paintings, :attachable_type
    add_column :paintings, :paintable_id, :integer
    add_column :paintings, :paintable_type, :string
  end
end
