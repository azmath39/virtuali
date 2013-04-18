class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :adjustable_amount
      t.integer :activity_type

      t.timestamps
    end
  end
end
