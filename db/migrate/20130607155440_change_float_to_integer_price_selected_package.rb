class ChangeFloatToIntegerPriceSelectedPackage < ActiveRecord::Migration
  def self.up
   change_table :selected_packages do |t|
     t.change :price, :integer
   end
  end

  def down
  change_table :selected_packages do |t|
     t.change :price, :float
   end

  end
end
