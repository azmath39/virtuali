ActiveAdmin.register CouponTransaction do
   menu :priority => 5
  config.clear_action_items!
  config.per_page = 10

index do
   column "Trancation Date", :created_at
   column  :coupon_code
   column "Coupon value($)" ,:coupon_value
    column "Full Name", :name
    column :email
    #default_actions
  end
      
end
