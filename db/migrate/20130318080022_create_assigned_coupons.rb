class CreateAssignedCoupons < ActiveRecord::Migration
  def change
    create_table :assigned_coupons do |t|
      t.integer :coupon_id
      t.integer :user_id
      t.date :valid_date
      t.timestamps
    end
  end
end
