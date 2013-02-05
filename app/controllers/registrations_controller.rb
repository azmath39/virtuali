class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  def create
    @user=User.new(params[:user])
    token = params[:stripeToken]

    # create the charge on Stripe's servers - this will charge the user's card
    charge = Stripe::Charge.create(
      :amount => 1000, # amount in cents, again
      :currency => "usd",
      :card => token,
      :description => params[:user][:email]
    )
    super
  end
end
