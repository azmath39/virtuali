class StatusesController < ApplicationController
  def show
    @users = User.all
    @tours = Tour.all
  end
end
