class PackagesController < ApplicationController
  def show
    @arg= params["products"].split(",")
    @products=[]
    @arg.each do |a|
      @products<<Product.find(a)
    end
    render :layout => false
  end
end
