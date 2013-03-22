ActiveAdmin.register Coupon do
 menu :priority => 5
  index do
    column :code
    column "Expires On", :expire_date
    column "Valid until", :valid_date
    column :value
    column :company
    column :company_email
    default_actions
  end
    
  form do |f|
    f.inputs "Coupon Details" do
      f.input :company
      f.input :expire_date
      f.input :valid_date
      f.input :company_email
      f.input :value

    end
    f.actions
  end
end
