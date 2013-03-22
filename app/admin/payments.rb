ActiveAdmin.register Payment do
  config.clear_action_items!
  index do
    column :amount
    column :reference
    column :payment_type
    column :created_at
    default_actions
  end
end
