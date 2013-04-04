class AddNameAndEmailToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :email, :string
    add_column :payments, :name, :string
    add_column :payments, :product_id, :integer
  end
end
