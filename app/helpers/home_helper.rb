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
(@selected_pkg.created_at.to_date)+30
  end
  def pictures
@selected_pkg.package.pictures_for_tour
  end
end
