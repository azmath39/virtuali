class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!
  
  rescue_from Stripe::CardError do |exception|
 render :text=>exception
  end
  private



  def stripe_charge
    @charge = Stripe::Charge.create(
      :amount => @total_amount, # amount in cents, again
      :currency => "usd",
      :card => @token,
      :description => @email
    )
  end

  def save_stripe_customer_id(user, customer)
    user.card=Card.create(:customer_stripe_id=>customer)
  end

  def get_stripe_customer_id
    current_user.card.customer_stripe_id
  end

  def subscription
  plan= Stripe::Plan.create(
  :amount => @total_amount,
  :interval => 'month',
  :name => @email,
  :currency => 'usd',
  :id => @token)

   @customer = Stripe::Customer.create(
      :card => @token,
      :plan => plan.id,
      :email => @email )
     save_stripe_customer_id(current_user, @customer.id) unless current_user.nil?

  end

  def unsubscribe
    customer_id=get_stripe_customer_id
    cu= Stripe::Customer.retrieve(customer_id)
    if cu.cancel_subscription
      Card.find_by_customer_stripe_id(get_stripe_customer_id).destroy
      "Your Direct Debit has been cancelled Successfully. Kindly refresh your page to reflect changes."
    else
      "For some reason, we are unable to cancel your Direct Debit. Try some other time. Sorry for inconvience. "
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
      :description => @email
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
