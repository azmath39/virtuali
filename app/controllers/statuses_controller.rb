class StatusesController < ApplicationController
  def show
    @users = User.all
    @tours = Tour.all
  end
  def webhooks_status
    @type = params["type"]
    if params["data"]["object"].has_key? "customer"

      puts "direct_debit payment" * 10
      #@customer = Card.find_by_customer_stripe_id(params["data"]["object"]["customer"])

      case @type
      when "invoice.payment_succeeded"
        puts "invoice.payment_succeeded"*10
        #puts @customer
      when "invoice.payment_failed"
        puts "invoice.payment_failed"*10
        #puts @customer
      when "customer.subscription.created"
        puts "customer.subscription.created"*10
        #puts @customer
      when "customer.subscription.deleted"
        puts "customer.subscription.deleted"*10
        #puts @customer
      end
   

    else
      puts "card payment" * 100
    end
    render :nothing
  end
end
