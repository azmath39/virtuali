class AddAcreageToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :acreage, :string
  end
end
