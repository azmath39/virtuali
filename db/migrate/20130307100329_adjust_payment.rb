class AdjustPayment < ActiveRecord::Migration
  def change
    remove_column :payments, :email
    remove_column :payments, :card_type
    remove_column :payments, :card_last4
    add_column :payments, :type, :integer
  end
end
