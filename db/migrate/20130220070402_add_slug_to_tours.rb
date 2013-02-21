class AddSlugToTours < ActiveRecord::Migration
  def change
    add_column :tours, :cached_slug, :string
  end
end
