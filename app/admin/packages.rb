#ActiveAdmin.register Package do
#  menu :parent => "Admin Options"
#  form do |f|
#    f.inputs "Package" do
#      f.input :name
#      f.input :package_type, :as=>:select, :collection=>[["Regular",1],["Combo",2]]
#      f.input :no_of_tours,:label=>'Tours Allowed',:as=>:select, :collection=>[["only One",1],["Unlimited",0]]
#      f.input :pictures_for_tour
#       #f.input :status, :as=>:select, :collection=>[["Publish",1],["UnPublish",2]]
#      #f.input :subscription_period, :label=>"Period of Subscription (in year)"
#      f.input :product, :label=>"Category"
#      f.input :regular_price,:label=>"Regular Price"
#      f.input :special_price, :label=>"Special Price (if any?)"
#
#    end
#    f.actions
#  end
#  index do
#
#    column :name
#    column "Package Type", :package_type_to_string
#    column "No Of Tours", :tours_allowed
#    column :pictures_for_tour
#    column "Category", :product
#    column :regular_price
#    column :special_price
#
#
#
#
#    default_actions
#  end
#end
