class HomeController < ApplicationController
  def index
    
  end
  def billing_page

  end
  def status
    @selected_pkgs = selected_pkgs_with_tour
  end
  private
  def selected_pkgs_with_tour
   pkgs= current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
    return pkgs
  end
end
