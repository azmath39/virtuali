module ApplicationHelper
  def verify_tours_allowed
    if current_user.selected_package.package.no_of_tours==1
      if current_user.tours.count==1
        return false
      end
    end
    return true
  end

  def price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "$#{pkg.regular_price}/month (or) $#{pkg.special_price}/year "
  elsif !pkg.special_price.nil?
      "$#{pkg.regular_price}/month"
    else
      "$#{pkg.regular_price}/ 3 months"

    end
  end
  def just_price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "#{pkg.regular_price}<sub id ='per-month'>/month</sub> (or) #{pkg.special_price}<sub id ='per-month'>/year</sub> ".html_safe
  elsif !pkg.special_price.nil?
    "#{pkg.regular_price}<sub id ='per-month'>/Month</sub>".html_safe
    else
      "#{pkg.regular_price}<sub id ='per-month'>/3Months</sub>".html_safe

    end
  end
  def actual_price(pkg)
    if !current_user.nil? and current_user.special_offer and !pkg.special_price.nil?
      "$#{pkg.regular_price/0.85}/month (or) $#{pkg.special_price/0.85}/year "
  elsif !pkg.special_price.nil?
      "$#{pkg.regular_price/0.85}/month"
    else
      "$#{pkg.regular_price/0.85}/ 3 months"

    end
  end
end
