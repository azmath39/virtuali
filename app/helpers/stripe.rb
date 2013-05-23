# To change this template, choose Tools | Templates
# and open the template in the editor.

module Stripe
 def stripe_charge
    @charge = Stripe::Charge.create(
      :amount => @amount, # amount in cents, again
      :currency => "usd",
      :card => @token,
      :description => @email
    )
    current_user.save_payment_details(@charge["id"],1,@charge[:amount]) unless current_user.nil?
  end

  def save_stripe_customer_id(user, customer)
    user.card=Card.create(:customer_stripe_id=>customer)
  end

  def get_stripe_customer_id
    current_user.card.customer_stripe_id
  end

  def subscription
  plan= Stripe::Plan.create(
  :amount => @amount,
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
end
