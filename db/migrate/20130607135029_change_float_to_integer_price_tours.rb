class ChangeFloatToIntegerPriceTours < ActiveRecord::Migration
  def self.up
   change_table :tours do |t|
     t.change :price, :integer
    end
  end

  def self.down
     change_table :tours do |t|
       t.change :price, :float
     end
  end
end
