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
@selected_pkg.created_at.to_date
  end
  def end_date
    @selected_pkg.renew_date
  end
  def pictures
   @selected_pkg.pictures_for_tour
  end
  def verify_renew_date
    if @selected_pkg.renew_date<Date.today+15
      true
    else
      false
    end
  end
  def check_payment_type
    if @selected_pkg.payment_period_type==1
      true
    else
      false
    end
  end
end
