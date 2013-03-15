class HomeController < ApplicationController
 before_filter :verify_account_validity, :only=>["index"]
  def validate_email
    user=User.find_by_email(params[:email])
    if user.nil?
      render :text=>1
    else
      render :text=>0
    end
  end
  def index
    if current_user
      if current_user.subscribe_product.count>1
        redirect_to :action=>:select_product_view
      end
      @feedback = Feedback.new
      @tours= current_user.tours
      @packages= Package.all
      #@payments=current_user.payments.order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
      @payments=current_user.payments.order('created_at DESC')
      #@selected_pkgs = selected_pkgs_with_tour
    end
  end

  def select_product_view
    if params.include?:product
       @feedback = Feedback.new
      @tours= current_user.tours.where(:product_id=>params[:product][:id])
      @packages= Package.all
      #@payments=current_user.payments.order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
      @payments=current_user.payments.order('created_at DESC')
      render 'index'
    end
    @products=current_user.subscribe_product
  end
  def cancel_direct_debit
    mess= unsubscribe
    render :text=>mess
  end

  def make_payment
    @token = params[:stripeToken]
    @email= current_user.email
    if params[:operation_type].to_i==1 then
      @pkg_id = params[:pkg_id].to_i
      renew

    elsif params[:operation_type].to_i==2 then
      create_direct_debit
    else
      flash[:error]="Opps! Unknown Operation"
    end
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
  

  

  def state_cities
    state=State.find_by_name(params[:state])
    @cities= City.find(:all,:conditions=>{:code=>state.code}) unless state.nil?
    @str=""
    unless @cities.empty?
      @str +="'<option value="">Select City</option>"
      @cities.each do |c|
        @str += "<option value=#{c.name}>#{c.name}</option>"
      end
      @str +="'"
    end
    render :text=>@str
  end
  def account_activation
    @s_pkg=current_user.selected_package
  end
  private

  #  def selected_pkgs_with_tour
  #    pkgs= current_user.selected_packages.select do|spkg|
  #      spkg unless spkg.tour.nil?
  #    end
  #    return pkgs
  #  end
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

  def renew
    @selected_pkg=SelectedPackage.find(@pkg_id)
    @amount = (@selected_pkg.price.to_f*100).to_i
    stripe_charge
    if @selected_pkg.tours_enable
      
      flash[:notice]="sucessfully renewed"
    else
      flash[:error]= "Unable to update at this movement, Try some other time. Sorry for the inconvience."

    end
  end
  def create_direct_debit
    @amount = (current_user.selected_package.price.to_f*100).to_i
    subscription
    #current_user.save_payment_details(nil,3,@amount)
  end

end
