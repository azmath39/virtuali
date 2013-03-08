class PackagesController < ApplicationController
  def show
    product=Product.find(params["product"].to_i)
    @packages= product.packages
    render :layout => false
  end
  def total_value
    pkg=Package.find(params["package_id"].to_i)
    payment_type=choose_payment_type.to_i

    if payment_type==1 and !pkg.nil? and !pkg.monthly_price.nil?
      @value = pkg.monthly_price
    else
      @value = pkg.yearly_price
    end

    render :text=>@value
  end
  def upgrade_package
    @packages=current_user.packages_for_upgarde
    
  end
  def upgrade
    @token = params[:stripeToken]

    #@amount =(current_user.ajust_amount(params[:total_amount]).to_f*100).to_i
    @amount =(params[:total_amount].to_f*100).to_i
    @email= current_user.email

    payment() unless @amount<6
    current_user.upgrade_package(params[:package])
    redirect_to root_url
  end
  
  def destroy_user_package
    current_user.package_destroy
    flash[:notice]="Sucessfully Deleted Your Package and Related Tours"
    redirect_to root_url
  end


  private

  def payment()
#    if current_user.selected_package.payment_period_type==1
#      if current_user.card.nil?
#        stripe_charge
#      else
#        change_plan
#
#      end
#    else
#      stripe_charge
#    end
  stripe_charge
  end
  def change_plan

    cu = Stripe::Customer.retrieve(get_stripe_customer_id)
#    plan_id=cu.subscription.plan.id
    plan= Stripe::Plan.create(
      :amount => @amount,
      :interval => 'month',
      :name => @email,
      :currency => 'usd',
      :id => @token)
    cu.subscription.plan.delete
    cu.description = "Customer for test@example.com"
    cu.plan=plan # obtained with Stripe.js
    cu.save
   
  end
  def choose_payment_type
    if params.include?"type_of_payment"
      params["type_of_payment"]
    elsif !current_user.nil?
      current_user.selected_package.payment_period_type
    else
      2
    end
  end

end
