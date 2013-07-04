module HomeHelper
#  def package_status(pkg)
#    @selected_pkg=pkg
#    if Date.today <=(@selected_pkg.created_at).to_date + 30
#      "active"
#    else
#      "inactive"
#    end
#  end
  def initiate(pkg)
      @selected_pkg=pkg
  end
  def start_date
      @selected_pkg.created_at.strftime("%b-%d-%Y")
  end
  def end_date
      @selected_pkg.renew_date.strftime("%b-%d-%Y")
  end
  def pictures
      @selected_pkg.pictures_for_tour
  end
  def description
    description = "Name: #{@selected_pkg.package_name}<br />
    No.of Tours: #{@selected_pkg.package_no_of_tours}<br />
    Price: $#{@selected_pkg.price}<br />
    Subscription Period: #{@selected_pkg.subscribed_days} Days"
    description.html_safe
  end
  def verify_renew_date
     @selected_pkg.renew_date<Date.today+15
  end
  def check_payment_type
      @selected_pkg.payment_period_type == 1
  end
  def space20
    str = String.new
    20.times{ str += "&nbsp;"}
    str.html_safe
  end
end
