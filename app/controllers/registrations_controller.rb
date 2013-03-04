class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    build_resource
    @token = params[:stripeToken]
    @amount = (params[:total_amount].to_f*100).to_i
    @email= params[:user][:email]
    payment
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
    # create the charge on Stripe's servers - this will charge the user's card 
  end

  private
  def payment()
    if params[:user][:package].include?(:type_of_payment) and params[:user][:package][:type_of_payment]==2
      if params[:type_of_transaction] == "1"
        stripe_charge
      elsif params[:type_of_transaction] == "2"
        subscription
        save_stripe_customer_id(resource, @customer.id)
      end
    else
      stripe_charge
    end
  end
end