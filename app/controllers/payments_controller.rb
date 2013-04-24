class PaymentsController < ApplicationController

  #layout 'authorize_net'
  helper :authorize_net
  protect_from_forgery :except => :relay_response

  # GET
  # Displays a payment form.
#  def payment
#    @amount = 10.00
#    @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
#    @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::GET, :link_text => 'Continue', :link_url => payments_thank_you_url(:only_path => false)))
#  end
 
  def renew
    @amount = current_user.package_price
    @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
    @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => payments_renew_successfull_url(:only_path => false)))


  end

  
  def upgrade
    @amount =amount_to_charge
    @email= current_user.email
  
    add_coupon
    @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
    if params.include?:user and !params.include?:package
      session[:package]=params[:user][:package]
      session[:product]=params[:user][:product]
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => upgrade_combo_packages_url(:only_path => false)))
    else
      session[:package]=params[:package]
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => upgrade_packages_url(:only_path => false)))
    end
    render 'payment'
  end

  def renew_successfull
    current_user.save_payment_details(params[:x_trans_id],params[:x_card_type],params[:x_amount])
    current_user.selected_package.renew_package
    @auth_code = params[:x_auth_code]
    render 'thank_you', :layout=>false
  end


  # GET
  # Displays a thank you page.
  def thank_you
    @auth_code = params[:x_auth_code]
  end

def save_user

    @user=User.new(session[:params][:user])
    if @user.save
        @user.company= Company.new(params[:company]) if params.include?:company
       if @user.active_for_authentication?
       # flash[:notice, :signed_up if is_navigational_format?
         sign_up("user", @user)
         respond_with @user, :location => after_sign_up_path_for(@user)
       else

         set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_navigational_format?
          expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(@user)
       end
     else
  #      refund_payment(@charge["id"])
      #clean_up_passwords @user
       redirect_to :new_user_registration
     end
    
  

  end

  private
  def amount_to_charge
    if params.include?:user and params[:user].include?:coupon
      params[:user][:coupon][:amount].to_f
      #current_user.coupon=(params[:user][:coupon])
    else
      params[:total_amount].to_f
    end
  end
  def add_coupon
    if params.include?:user and params[:user].include?:coupon
      current_user.coupon=(params[:user][:coupon])
      current_user.add_coupon_transaction
    elsif current_user.any_coupon?
      current_user.add_coupon_transaction
    end
  end

end