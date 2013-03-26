ActiveAdmin.register Feedback do
  config.clear_action_items!
  actions :index,:destroy, :show
   menu :priority => 7
   config.per_page = 10
  index do

    column "Date Time", :created_at
    column "Name", :user_name
    column "Mail", :user_email
    column :opinion
    
    default_actions
   
  end
end
