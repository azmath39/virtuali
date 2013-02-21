class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    build_resource
    @token = params[:stripeToken]
    @total_amount = (params[:total_amount].to_f*100).to_i
if params[:type_of_transaction] == "1"
  stripe_charge
elsif params[:type_of_transaction] == "2"
 
  subscription
  save_stripe_customer_id(resource, @customer.id)
end
    

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

  def stripe_charge
    @charge = Stripe::Charge.create(
      :amount => @total_amount, # amount in cents, again
      :currency => "usd",
      :card => @token,
      :description => params[:user][:email]
    )


  end

  
  def save_stripe_customer_id(user, customer)
    user.card=Card.create(:customer_stripe_id=>customer)
  end
  def get_stripe_customer_id
    (Card.find(:last)).customer_stripe_id
  end
  def subscription
 plan= Stripe::Plan.create(
  :amount => @total_amount,
  :interval => 'month',
  :name => params[:user][:email],
  :currency => 'usd',
  :id => @token
)

    @customer = Stripe::Customer.create(
      :card => @token,
      :plan => plan.id,
      :email => params[:user][:email]
    )
    
  end
  def unsubscribe
    customer_id=get_stripe_customer_id
    cu= Stripe::Customer.retrieve(customer_id)
    if cu.cancel_subscription
      Card.find_by_customer_stripe_id(get_stripe_customer_id).destroy
    else
      render :text=>"UnIdentified Customer"
    end

  end
   def change_plan
      cu = Stripe::Customer.retrieve(get_stripe_customer_id)
      cu.description = "Customer for test@example.com"
      cu.plan='xxxx' # obtained with Stripe.js
      cu.save
    end

def save_card_reuse
    @customer = Stripe::Customer.create(
      :card => @token,
      :description => params[:user][:email]
    )
    save_stripe_customer_id(@user, @customer.id)
    @charge = Stripe::Charge.create(
      :amount => @total_amount, # in cents
      :currency => "usd",
      :customer => @customer.id
    )

  end
  def use_previous_card
    @charge = Stripe::Charge.create(
      :amount => @total_amount, # in cents
      :currency => "usd",
      :customer => get_stripe_customer_id
    )
  end








end