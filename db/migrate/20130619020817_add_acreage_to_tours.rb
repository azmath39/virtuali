class AddAcreageToTours < ActiveRecord::Migration
  def change
    add_column :tours, :acreage, :string
  end
end
