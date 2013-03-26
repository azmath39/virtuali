ActiveAdmin.register Payment do
  config.clear_action_items!
  actions :index, :show
   menu :priority => 6
   config.per_page = 10
  index do
    column "Transaction Date", :created_at
    column  "Transaction Reference",:reference
    column "Transaction Type",:payment_type_info
    column :amount
    
    #default_actions
  end
end
