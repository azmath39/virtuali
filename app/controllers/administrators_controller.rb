class AdministratorsController < ApplicationController
  def webhooks_handling
    @type = params["type"]
    if params["data"]["object"].has_key? "customer"
      @card = Card.find_by_customer_stripe_id(params["data"]["object"]["customer"])
      @customer=@card.user unless @card.nil?
      update_selected_package_status(@type,@customer) unless @customer.nil?
    end
    render :nothing=>true
  end
  def user_account_maintenance
    puts "hdbhfb"*10
    disable_tours
    delete_tours
    inform_users
  end
  private
  def disable_tours

    #selected_pkgs= SelectedPackage.where(:renew_date=>Date.yesterday,:status=>[0,1])
    selected_pkgs=SelectedPackage.all
    selected_pkgs.each do |s_pkg|
      puts s_pkg
      s_pkg.tours_disable
    end unless selected_pkgs.empty?
  end
  def delete_tours
    selected_pkgs= SelectedPackage.where(:renew_date=>Date.yesterday-15,:status=>[2,3])
    selected_pkgs.each do |s_pkg|
      s_pkg.tours_destroy
    end unless selected_pkgs.empty?
  end
  def inform_users
    selected_pkgs= SelectedPackage.where(:renew_date=>(Date.today..Date.today+15),:status=>[0,1])
    selected_pkgs.each do |s_pkg|
      s_pkg.send_alert_message
    end unless selected_pkgs.empty?
  end
  def update_selected_package_status(type,customer)
    case type
    when "invoice.payment_succeeded"
      customer.selected_packages.where(:status=>(0..2)).each do |select_pkg|
        select_pkg.update_attributes(:status=>1,:expire_date=> select_pkg.expire_date + 30)
        select_pkg.tour.update_attributes(:status=>1)
      end
      #puts @customer
    when "invoice.payment_failed"
      customer.selected_packages.where(:status=>(0..2)).each do |select_pkg|
        select_pkg.update_attributes(:status=>2)
        select_pkg.tour.update_attributes(:status=>2)
      end
      #puts @customer
    when "customer.subscription.created"
      #puts "customer.subscription.created"*10
      #puts @customer
    when "customer.subscription.deleted"
      customer.selected_packages.each do |select_pkg|
        select_pkg.update_attributes(:status=>2)
        select_pkg.tour.update_attributes(:status=>2)
      end
      #puts @customer
    end
  end

end
