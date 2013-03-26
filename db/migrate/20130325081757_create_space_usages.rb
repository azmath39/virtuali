class CreateSpaceUsages < ActiveRecord::Migration
  def change
    create_table :space_usages do |t|
      t.float :size

      t.timestamps
    end
  end
end
