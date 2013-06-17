class PagesController < ApplicationController
  def about_vi

  end
  def products

  end
  def faq

  end
  def tutorial
    
  end
def display 
@product=Product.new(params["Product"])
@product.save
end
end
