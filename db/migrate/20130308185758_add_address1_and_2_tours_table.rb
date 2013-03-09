class AddAddress1And2ToursTable < ActiveRecord::Migration
  def change
   add_column :tours, :address1, :string
   add_column :tours, :address2, :string
  end
end
