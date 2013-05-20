class DraftsController < ApplicationController
  def edit
    @draft=Draft.find(params[:id])
    @paintings=@draft.paintings
     @painting=Painting.new
     @products = current_user.subscribe_product
    #@priority=get_priority
  end
  def update

  end

  def show
  end

  def index
    @drafts=Draft.all
  end
  private

end
