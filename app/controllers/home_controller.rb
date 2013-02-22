class HomeController < ApplicationController
  def index
    if current_user
    @feedback = Feedback.new
    @selected_pkgs = selected_pkgs_with_tour
    end
  end

  def cancel_direct_debit
   mess= unsubscribe
   render :text=>mess
  end

  private

  def selected_pkgs_with_tour
   pkgs= current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
    return pkgs
  end
end
