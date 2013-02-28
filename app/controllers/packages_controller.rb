class PackagesController < ApplicationController
  def show
    
    product=Product.find(params["product"].to_i)
    @packages= product.packages
   
    render :layout => false
  end
  def total_value
    
    
      @value = Package.find(params["package_id"].to_i).price
  
   
    render :text=>@value
  end
end
