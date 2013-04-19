class AddTimestampsToMessages < ActiveRecord::Migration
  def change
    change_table(:messages){|t| t.timestamps}
  end
end
