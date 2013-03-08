class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :add1, :string
    add_column :users, :add2, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :zipcode, :string
  end
end
