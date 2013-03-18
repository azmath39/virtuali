class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :company
      t.date :expire_date
      t.date :valid
      t.string :company_email

      t.timestamps
    end
  end
end
