class CreateCouponTransactions < ActiveRecord::Migration
  def change
    create_table :coupon_transactions do |t|
      t.integer :user_id
      t.integer :coupon_id
      t.string :email
      t.string :name
      t.timestamps
    end
  end
end
