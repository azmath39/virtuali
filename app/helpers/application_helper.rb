module ApplicationHelper
  def verify_tours_allowed
    if current_user.selected_package.package.no_of_tours==1
      if current_user.tours.count==1
        return false
      end
    end
    return true
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == params[:sort] ? "current #{params[:direction]}" : nil
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, {:sort => column,  :direction => direction}, {:class => css_class}
  end
end
