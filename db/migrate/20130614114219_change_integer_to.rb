class ChangeIntegerTo < ActiveRecord::Migration
  def self.up 
  change_table :paintings do |t|
     t.change :select_image, :string
   end
  
  end

  def down
  end
end
