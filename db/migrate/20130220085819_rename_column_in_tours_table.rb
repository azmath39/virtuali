class RenameColumnInToursTable < ActiveRecord::Migration
  def change
    rename_column :tours, :cached_slug, :slug
  end
end
