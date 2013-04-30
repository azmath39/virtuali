class AddBalanceToActivies < ActiveRecord::Migration
  def change
    add_column :activities, :balance, :float
    add_column :activities, :charge, :float
    rename_column:activities, :adjustable_amount, :refund
  end
end
