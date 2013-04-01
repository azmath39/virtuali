class CompaniesController < ApplicationController
  def new
    @product = Product.find(params["product"].to_i)
    if @product.category.name == "By Agent"
      render :partial=>'new'
    else
      render :nothing => true
    end
  end
  def edit
    @company = current_user.company
  end
end
