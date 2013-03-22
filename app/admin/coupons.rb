ActiveAdmin.register Coupon do
   menu :priority => 5
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
