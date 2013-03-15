class AddPackageTypeToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :package_type, :integer
  end
end
