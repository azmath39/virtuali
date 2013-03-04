class PackagesController < ApplicationController
  def show
    product=Product.find(params["product"].to_i)
    @packages= product.packages
    render :layout => false
  end
  def total_value
    pkg=Package.find(params["package_id"].to_i)
   if params["type_of_payment"].to_i==1 and !pkg.nil?
     @value = pkg.monthly_price
   else
      @value = pkg.yearly_price
   end
    render :text=>@value
  end
  def upgrade_package
    @packages=current_user.selected_product.product.packages
  end
  def upgrade
   @token = params[:stripeToken]
    @amount = (params[:total_amount].to_f*100).to_i
    @email= current_user.email
    payment()
  current_user.upgrade_package(params[:package])
  redirect_to root_url
  end
  private
  def payment()
    if params[:package].include?(:type_of_payment) and params[:package][:type_of_payment]==2
      if params[:type_of_transaction] == "1"
        stripe_charge
      elsif params[:type_of_transaction] == "2"
        subscription
        save_stripe_customer_id(resource, @customer.id)
      end
    else
      stripe_charge
    end
  end
end
