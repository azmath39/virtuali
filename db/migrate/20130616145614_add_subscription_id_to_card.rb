class AddSubscriptionIdToCard < ActiveRecord::Migration
  def change
    rename_column :cards,:customer_stripe_id, :subcription_id

  end
end
