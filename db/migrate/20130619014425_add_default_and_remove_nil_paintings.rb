class AddDefaultAndRemoveNilPaintings < ActiveRecord::Migration
  def up
    change_column :paintings, :select_image, :boolean, :default => 0
    Painting.update_all({ :select_image => 0 }, { :select_image => nil })
  end

  def down
  end
end
