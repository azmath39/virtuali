class PackagesController < ApplicationController
  def show
    @arg= params["products"].split(",")
    @products=[]
    @arg.each do |a|
      @products<<Product.find(a)
    end
    render :layout => false
  end
  def total_value
    @arg= params["packeges"].split(",")
    @value=0
    @arg.each do |a|
      @value+=Package.find(a).price
    end
   
    render :text=>@value
  end
end
