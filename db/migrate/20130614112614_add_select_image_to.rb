class AddSelectImageTo < ActiveRecord::Migration
  def up
    add_column :paintings, :select_image, :string
  end

  def down
  end
end
