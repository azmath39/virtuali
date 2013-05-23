class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!
  
  
# rescue_from Stripe::CardError do |exception|
# flash[:error]=exception.message
# redirect_to :back
#  end
#rescue_from Stripe::InvalidRequestError do |exception|
#  flash[:error]= exception.message
#  redirect_to :back
#end

def verify_account_validity
  unless current_user.nil?
    unless current_user.account_valid
     flash[:error]="Your account as either exipered or cancled by You. Buy new package to continue..  "
      redirect_to :action=>"upgrade_package",:controller=>"packages"
    end
  end
end


  private
  #include Stripe
end
