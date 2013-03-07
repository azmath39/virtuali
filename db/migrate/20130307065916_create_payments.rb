class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :amount
      t.string :reference
      t.string :card_type
      t.integer :card_last4
      t.string :email
      t.timestamps
    end
  end
end
