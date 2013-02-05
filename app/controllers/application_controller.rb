class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!
  rescue_from Stripe::CardError do |exception|
 render :text=>exception
end
  
end
