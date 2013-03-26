ActiveAdmin.register CouponTransaction do
  menu :priority => 5
  config.clear_action_items!
  config.per_page = 10
  actions :index

  filter :coupon_id , :as => :select,:label=>'Company Name', :collection => Coupon.all.collect{|x| [x.company,x.id]}
  filter :coupon_id , :as => :select, :label=>'Value', :collection => Coupon.all.collect{|x| [x.value,x.id]}
  filter :created_at
  filter :name, :label=>"Full Name"

  index do
    column "Trancation Date", :created_at
    column  :coupon_code
    column "Coupon value($)" ,:coupon_value
    column "Full Name", :name
    column :email
    #default_actions
  end
      
end
