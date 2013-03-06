class CreateUserDelayJobs < ActiveRecord::Migration
  def change
    create_table :user_delay_jobs do |t|
      t.integer :user_id
      t.integer :delayed_job_id

      t.timestamps
    end
    remove_column :delayed_jobs, :user_id
  end
end
