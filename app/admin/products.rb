#ActiveAdmin.register Product do
#  menu :parent => "Admin Options"
#  form do |f|
#    f.inputs "Product Details" do
#      f.input :name, :label=>"Product Name"
#      f.input :product_type, :as=>:select, :collection=>[["Regular",1],["Combo",2]]
#      f.input :category
#
#    end
#    f.actions
#  end
#  index do
#    column :name
#    column "Type", :product_type_to_string
#    column :category
#    column "Created At", :created_at
#  end
#end
