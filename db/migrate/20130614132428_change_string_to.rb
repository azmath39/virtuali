class ChangeStringTo < ActiveRecord::Migration
  def up
    change_table :paintings do |t|
     t.change :select_image, :boolean
   end
  end

  def down
        change_table :paintings do |t|
     t.change :select_image, :boolean, :default=>0
   end
  end
end
