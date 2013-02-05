class RemoveUserIdFromPackages < ActiveRecord::Migration
  def up
    remove_column :packages, :user_id
  end

  def down
    add_column :packages, :user_id, :integer
  end
end
