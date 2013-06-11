class RegistrationsController < Devise::RegistrationsController
  helper :authorize_net
  protect_from_forgery :except => :relay_response
  def new
    resource = build_resource({})
    if params.include?(:package_id)
      @package=Package.find(params[:package_id])

      @product=@package.product.id
      @notice="You have selected #{@package.name} package of #{@package.product.name} "
      render  'instant_sign_up'
    else
      respond_with resource
    end
  end
  def create
    build_resource
      
    @amount = amount_to_charge
    @email= params[:user][:email]
    if resource.save
      resource.company= Company.new(params[:company]) if params.include?:company
      session[:user_id]=resource.id
#      if params[:type_of_payment].to_i !=1
      @product="#{Product.find(params[:user][:product]).name} #{Package.find(params[:user][:package][:id]).name}"
      @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => registrations_save_user_url(:only_path => false)))
    render '/payments/payment'
#      else
#      render '/payments/payment_form'
#      end
    else
      #      refund_payment(@charge["id"])
      clean_up_passwords resource
      respond_with resource
    end
    # create the charge on Stripe's servers - this will charge the user's card
  end
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    if resource.update_with_password(params[:user])
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_to do|format|
        format.html {respond_with resource, :location => after_update_path_for(resource)}
        format.js
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def save_user
    resp = AuthorizeNet::SIM::Response.new(params)
    resource=User.find(session[:user_id])
    session[:user_id]=nil
    if resp.approved?
      resource.save_payment_details(params[:x_trans_id],params[:x_card_type],params[:x_amount])
      resource.trace_activity
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
      resource.destory
      redirect_to root_url
    end
  end
  
  def edit
    render :layout => false
  end

  
  private
  def amount_to_charge
    if params[:user].include?:coupon
      params[:user][:coupon][:amount].to_f
    else
      params[:total_amount].to_f
    end
  end
  #  def payment()
  #    if params[:user][:package].include?(:type_of_payment) and params[:user][:package][:type_of_payment].to_i==1
  #      if params[:type_of_transaction] == "1"
  #        stripe_charge
  #        resource.save_payment_details(@charge["id"],1,@charge[:amount])
  #      elsif params[:type_of_transaction] == "2"
  #        subscription
  #        save_stripe_customer_id(resource, @customer.id)
  #        resource.save_payment_details(nil,3,@amount)
  #      end
  #    else
  #      stripe_charge
  #      resource.save_payment_details(@charge["id"],1,@charge[:amount])
  #    end
  #  end
  #  def refund_payment(charge_id)
  #    ch = Stripe::Charge.retrieve(charge_id)
  #    refund= ch.refund
  #    a= refund[:amount].to_i/100
  #    Payment.create(:reference=>refund[:id],:amount=>a,:payment_type=>4)
  #  end
end