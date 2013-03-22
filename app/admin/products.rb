ActiveAdmin.register Product do
  menu :parent => "Admin Options"
  form do |f|
    f.inputs "Product Details" do
      f.input :category
      f.input :product_type, :as=>:select, :collection=>[["single",1],["Combo",2]]
      f.input :name, :label=>"Product Name"
      
    end
    f.actions
  end
end
