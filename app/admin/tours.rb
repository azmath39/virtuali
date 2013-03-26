ActiveAdmin.register Tour do
   menu :priority => 3
   config.per_page = 10
   form do|f|
      f.inputs "Tour" do
      f.input :product, :label=>"Category"
      f.input :user
      f.input :status, :as=>:select,:collection=>[['Active',1],['Inactive',4],['Sold',3]]
      f.input :square_footage
      f.input :price
      end
      f.actions
   end
   index do
    column "Tile", :name
    column "Category",:product_name
    column "Status", :tour_status
    column "Inactive From", :inactive_from
    column "location",:location
    column "User Name", :user

    column :square_footage
    column :price
  
    default_actions
  end
end
