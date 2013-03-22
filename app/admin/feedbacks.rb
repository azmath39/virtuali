ActiveAdmin.register Feedback do
  config.clear_action_items!
  index do
    column :satisfaction_status
    column "Name", :user
    column "Mail", :user_email
    column "Created On", :created_at
    default_actions
   
  end
end
