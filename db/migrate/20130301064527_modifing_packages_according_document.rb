class ModifingPackagesAccordingDocument < ActiveRecord::Migration
  def up
    add_column :packages, :subscription_period, :integer
    add_column :packages,:add_on, :integer
  end

  def down
    remove_column :packages, :subscription_period
    remove_column :packages,:add_on
  end
end
