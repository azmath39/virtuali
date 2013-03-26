ActiveAdmin.register Package do
 menu :parent => "Admin Options"
 form do |f|
   f.inputs "Package" do
     f.input :product
     f.input :package_type, :as=>:select, :collection=>[["single",1],["Combo",2]]
     f.input :name
     f.input :pictures_for_tour
     f.input :no_of_tours
     f.input :status, :as=>:select, :collection=>[["Publish",1],["UnPublish",2]]
     f.input :subscription_period, :label=>"Period of Subscription (in year)"
     f.input :regular_price
     f.input :special_price, :label=>"Special Price (if any?)"
     
   end
   f.actions
 end
end
