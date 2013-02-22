class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :satisfaction_status
      t.text :content

      t.timestamps
    end
  end
end
