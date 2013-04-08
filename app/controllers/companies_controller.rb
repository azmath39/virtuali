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
    @company = Company.find(params[:id])
  end
  def update
    @company = Company.find(params[:company][:id])
    if @company.update_attributes(params[:company])
      flash[:notice]="Company details updated successfully!"
      redirect_to root_path
    else
      render 'edit'
    end
  end
  def remove_logo
     if current_user.company.remove_logo!
       redirect_to :back, :notice => "Company logo removed."
     else
       
     end
  end
end
