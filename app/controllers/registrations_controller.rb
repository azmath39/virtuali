class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    build_resource
    @token = params[:stripeToken]
    @amount = amount_to_charge
    @email= params[:user][:email]
    payment
    if resource.save
      resource.company= Company.new(params[:company]) if params.include?:company
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else

        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      refund_payment(@charge["id"])
      clean_up_passwords resource
      respond_with resource
    end
    # create the charge on Stripe's servers - this will charge the user's card 
  end
  
  private
   def amount_to_charge
    if params[:user].include?:coupon
      (params[:user][:coupon][:amount].to_f*100).to_i
    else
      (params[:total_amount].to_f*100).to_i
    end
  end
  def payment()
    if params[:user][:package].include?(:type_of_payment) and params[:user][:package][:type_of_payment].to_i==1
      if params[:type_of_transaction] == "1"
        stripe_charge
        resource.save_payment_details(@charge["id"],1,@charge[:amount])
      elsif params[:type_of_transaction] == "2"
        subscription
        save_stripe_customer_id(resource, @customer.id)
        resource.save_payment_details(nil,3,@amount)
      end
    else
      stripe_charge
      resource.save_payment_details(@charge["id"],1,@charge[:amount])
    end
  end
  def refund_payment(charge_id)
   ch = Stripe::Charge.retrieve(charge_id)
   refund= ch.refund
   a= refund[:amount].to_i/100
   Payment.create(:reference=>refund[:id],:amount=>a,:payment_type=>4)
  end
end