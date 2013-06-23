class PaymentsController < ApplicationController

  #layout 'authorize_net'
  helper :authorize_net
  protect_from_forgery :except => :relay_response

  
  def renew
    @amount =amount_to_charge
    if @amount>0
      @email= current_user.email
      @product="#{current_user.product.name} #{current_user.package.name}"
      @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => payments_renew_successfull_url(:only_path => false)))
    else
      redirect_to :action=>'renew_successfull_zero_amount'
    end
  end
  def upgrade
    @amount =amount_to_charge
    #@email= current_user.email
 
    if params.include?:user and !params.include?:package
      combo_upgrade
    else
      normal_upgrade
    end
  end
  def create_recursive_payment
    @amount=current_user.package.regular_price
    @email=current_user.email
    @product="#{current_user.product.name} (#{current_user.package.name})"
    transaction = AuthorizeNet::ARB::Transaction.new('2Mp89hQ4', '4xr7VY5n6KQ3v6V8', :gateway => :sandbox)
    subscription = AuthorizeNet::ARB::Subscription.new(
      :name => @product,
      :length => 1,
      :unit => :month,
      :start_date => current_user.payment_date,
      :total_occurrences => 12,
      :amount =>@amount,
      :description => @product,
      :credit_card => AuthorizeNet::CreditCard.new(params[:card_no], params[:expire_date],:card_code=>params[:card_code]),
      :billing_address => AuthorizeNet::Address.new(:first_name => @email, :last_name =>'xxx')
    )
    @response = transaction.create(subscription)

   unless @response.subscription_id.nil?
    Card.create!(:subcription_id=>@response.subscription_id,:user_id=>session[:user_id])
   end
   render  'response'
  end
  def cancel_subscription
    transaction = AuthorizeNet::ARB::Transaction.new('2Mp89hQ4', '4xr7VY5n6KQ3v6V8', :gateway => :sandbox)
    subscription = AuthorizeNet::ARB::Subscription.new(
       :subscription_id=>current_user.card.subcription_id
    )
    @response = transaction.create(subscription)
     render  'response'

  end
  def change_card_details
    transaction = AuthorizeNet::ARB::Transaction.new('2Mp89hQ4', '4xr7VY5n6KQ3v6V8', :gateway => :sandbox)
    subscription = AuthorizeNet::ARB::Subscription.new(
       :subscription_id=>current_user.card.subcription_id,
       :credit_card => AuthorizeNet::CreditCard.new(params[:card_no], params[:expire_date],:card_code=>params[:card_code]),
       :billing_address => AuthorizeNet::Address.new(:first_name => @email, :last_name =>'xxx')
    )
    @response = transaction.update(subscription)
     render  'response'
  end
  def registration
    @amount=params[:amount]
    @email=params[:email]
    @product=params[:description]
    transaction = AuthorizeNet::ARB::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], :gateway => :sandbox)
    subscription = AuthorizeNet::ARB::Subscription.new(
      :name => @product,
      :length => 1,
      :unit => :month,
      :start_date => Date.today,
      :total_occurrences => 12,
      :amount =>@amount,
      :description => @product,
      :credit_card => AuthorizeNet::CreditCard.new(params[:card_no], params[:expire_date],:card_code=>params[:card_code]),
      :billing_address => AuthorizeNet::Address.new(:first_name => @email, :last_name =>'xxx')
    )
    response = transaction.create(subscription)
    
   unless response.subscription_id.nil?
   
    Card.create!(:subcription_id=>response.subscription_id,:user_id=>session[:user_id])
     #resource.save_payment_details(response.reference_id,"xxxx",@amount)
    redirect_to registrations_save_user_url
   else
     flash[:error]=response.message_text
    render 'payments/payment_form'
   end
  end

  def renew_successfull
    current_user.save_payment_details(params[:x_trans_id],params[:x_card_type],params[:x_amount])
    current_user.selected_package.renew_package
    current_user.change_balance(params[:x_amount])
    @auth_code = params[:x_auth_code]
    render 'thank_you', :layout=>false
  end
  def renew_successfull_zero_amount
    current_user.selected_package.renew_package  
    render 'thank_you', :layout=>false
  end
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
      @email= current_user.email
      @product="#{Product.find(params[:user][:product]).name} #{Package.find(params[:user][:package][:id]).name}"
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
      @email= current_user.email
      @product="#{current_user.product.name} #{Package.find(params[:package][:id]).name}"
      @sim_transaction = AuthorizeNet::SIM::Transaction.new(AUTHORIZE_NET_CONFIG['api_login_id'], AUTHORIZE_NET_CONFIG['api_transaction_key'], @amount, :hosted_payment_form => true)
      @sim_transaction.set_hosted_payment_receipt(AuthorizeNet::SIM::HostedReceiptPage.new(:link_method => AuthorizeNet::SIM::HostedReceiptPage::LinkMethod::POST, :link_text => 'Continue', :link_url => upgrade_packages_url(:only_path => false)))
      render 'payment'
    else
      redirect_to :controller=>"packages", :action=>"upgrade"
    end
  end

end