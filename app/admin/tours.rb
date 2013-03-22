ActiveAdmin.register Tour do
   menu :priority => 3
   config.per_page = 10
   index do
    column "Tile", :name
    column "Category",:product_name
    column "Status", :tour_status
    column "location",:location
    column "User Name", :user

    column :square_footage
    column :price
  
    default_actions
  end
end
