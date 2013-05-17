module ApplicationHelper
  def verify_tours_allowed
    if current_user.selected_package.package.no_of_tours==1
      if current_user.tours.count==1
        return false
      end
    end
    return true
  end
def cities_for_profile
  state=State.find_by_name(current_user.state)
  cities= City.find(:all,:conditions=>{:code=>state.code})
  cities.collect {|s| [s.name,s.name]}
end
  def price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "#{pkg.regular_price}<sub id='per-month'>/month</sub> (or) #{pkg.special_price}<sub id='per-month'>/year</sub> ".html_safe
    elsif !pkg.special_price.nil?
      "#{pkg.regular_price}<sub id='per-month'>/month</sub>".html_safe
    else
      "#{pkg.regular_price}<sub id='per-month'>/3months</sub>".html_safe

    end
  end
  def just_price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "#{pkg.regular_price.to_i}<sub id ='per-month'>/month</sub> (or) #{pkg.special_price.to_i}<sub id ='per-month'>/year</sub> ".html_safe
    elsif !pkg.special_price.nil?
      "#{pkg.regular_price.to_i}<sub id ='per-month'>/Month</sub>".html_safe
    else
      "#{pkg.regular_price.to_i}<sub id ='per-month'>/3Months</sub>".html_safe

    end
  end
  def actual_price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "#{(pkg.regular_price/0.85).to_i }<sub id ='per-month'>/month</sub> (or) #{(pkg.special_price/0.85).to_i}<sub id ='per-month'>/year</sub>".html_safe
    elsif !pkg.special_price.nil?
      "#{(pkg.regular_price/0.85).to_i}<sub id ='per-month'>/month</sub>".html_safe
    else
      "#{(pkg.regular_price/0.85).to_i}<sub id ='per-month'>/3months</sub>".html_safe

    end
  end
end
