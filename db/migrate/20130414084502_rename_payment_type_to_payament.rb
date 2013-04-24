class RenamePaymentTypeToPayament < ActiveRecord::Migration
  def change
    change_column :payments, :payment_type, :string
  end
end
