class HomeController < ApplicationController
  def index
    @feedback = Feedback.new
  end
end
