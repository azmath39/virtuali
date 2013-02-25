class HomeController < ApplicationController
  def index
    if current_user
      @feedback = Feedback.new
      @selected_pkgs = selected_pkgs_with_tour
    end
  end

  def cancel_direct_debit
    mess= unsubscribe
    render :text=>mess
  end
  def create_direct_debit
    @token = params[:stripeToken]
    @total_amount = (current_user.packages.sum(:price)*100).to_i
    @email = current_user.email
    subscription
  
    index
    render 'index'
  end
  def change_card_details
    @token = params[:stripeToken]
    change_card
    index
    render 'index'
  end
  def unsubsribe_package
    @selected_pkg=SelectedPackage.find(params[:id])
    @selected_pkg.tour.update_attributes(:status=>2)
    @selected_pkg.update_attributes(:status=>3)
    @amount=(current_user.selected_packages.sum(:price,:conditions=>{:status=>(0..2)}).to_f*100).to_i
    render :text=>cancel_payment()
  end
  def make_payment
    @token = params[:stripeToken]
    @selected_pkg=SelectedPackage.find(params[:pkg_id].to_i)
    @total_amount = (@selected_pkg.price.to_f*100).to_i
    @email= current_user.email
    stripe_charge
    if @selected_pkg.update_attributes(:status=>1)
      flash[:notice]="sucessfully renewed"
    else
     flash[:error]= "Unable to update at this movement, Try some other time. Sorry for the inconvience."
    index
    render 'index'
    end

  end

  private

  def selected_pkgs_with_tour
    pkgs= current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
    return pkgs
  end
  def change_card
    cu = Stripe::Customer.retrieve(get_stripe_customer_id)
    cu.card=@token
    cu.save
    #cu.update_subscription(:plan=>cu.plan,:card => @token,:protrate=>true)
    
    #      "Card Successfully changed."
    #    else
    #       "Sorry, We are unable to change Your card details. We apologies for the inconvience. "
    #    end
  end
  def cancel_payment



    cu = Stripe::Customer.retrieve(get_stripe_customer_id)
    # render :text=>cu
    plan_id=cu.subscription.plan.id
    cu.subscription.plan.delete
    plan= Stripe::Plan.create(
      :amount => @amount,
      :interval => 'month',
      :name => "testplan",
      :currency => 'usd',
      :id => plan_id)
    cu.plan=plan.id
    if cu.save
      "unsubscribed"
    end
   
    #    plan=Stripe::Plan.retrieve(cu.subscription.plan.id)
    #    plan.delete
    #
    # render :text=>plan.amount
  end

end
