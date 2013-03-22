ActiveAdmin.register CouponTransaction do
  config.clear_action_items!

index do
   column "Trancation Date", :created_at
    column "Full Name", :name
    column :email
    default_actions
  end
      
end
