class AddNamePhnoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    add_column :users, :phno, :string
  end
  def down
    remove_column :users, :name
    remove_column :users, :phno
  end
end
