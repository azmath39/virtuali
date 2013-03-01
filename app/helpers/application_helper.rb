module ApplicationHelper
  def verify_tours_allowed
    if current_user.selected_package.package.no_of_tours==1
      if current_user.tours.count==1
        return false
      end
    end
    return true
  end
end
