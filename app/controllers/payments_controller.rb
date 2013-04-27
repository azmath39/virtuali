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
    #add_coupon
    if params.include?:user and !params.include?:package
      combo_upgrade
    else
      normal_upgrade
    end
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
  def combo_upgrade
    session[:package]=params[:user][:package]
    session[:product]=params[:user][:product]
    if @amount>0
      @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => upgrade_combo_packages_url(:only_path => false)))
      render 'payment'
    else
      redirect_to :controller=>"packages", :action=>"upgrade_combo"
    end
  end
  def normal_upgrade
    session[:package]=params[:package]
    if @amount>0
      @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => upgrade_packages_url(:only_path => false)))
      render 'payment'
    else
      redirect_to :controller=>"packages", :action=>"upgrade"
    end
  end

end