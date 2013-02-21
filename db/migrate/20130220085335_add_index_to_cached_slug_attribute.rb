class AddIndexToCachedSlugAttribute < ActiveRecord::Migration
  def change
    add_index :tours, :cached_slug
  end
end
