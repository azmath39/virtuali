class StatusesController < ApplicationController
  def show
    @users = User.all
    @tours = Tour.all
  end
  def webhooks_status
    @type = params["type"]
    if params["data"]["object"].has_key? "customer"
      @card = Card.find_by_customer_stripe_id(params["data"]["object"]["customer"])
      @customer=@card.user unless @card.nil?
      case @type
      when "invoice.payment_succeeded"
        @customer.selected_packages.where(:status=>(0..2)).each do |select_pkg|
          select_pkg.update_attributes(:status=>1,:expire_date=> select_pkg.expire_date + 30)
          select_pkg.tour.update_attributes(:status=>1)
        end
        #puts @customer
      when "invoice.payment_failed"
        @customer.selected_packages.where(:status=>(0..2)).each do |select_pkg|
          select_pkg.update_attributes(:status=>2)
          select_pkg.tour.update_attributes(:status=>2)
        end
        #puts @customer
      when "customer.subscription.created"
        #puts "customer.subscription.created"*10
        #puts @customer
      when "customer.subscription.deleted"
        @customer.selected_packages.each do |select_pkg|
          select_pkg.update_attributes(:status=>2)
          select_pkg.tour.update_attributes(:status=>2)
        end
        #puts @customer
      end unless @customer.nil?

    #else
     # puts "card payment" * 100
    end
    render :nothing
  end
end
