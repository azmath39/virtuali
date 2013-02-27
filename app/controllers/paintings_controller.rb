class PaintingsController < ApplicationController
  
  def index
    #@painting = Painting.new
    @paintings = Painting.all
  end

  def show
    @painting = Painting.find(params[:id])
  end
  
  def new
    
    @paintings = Painting.where(:user_id=>current_user.id,:tour_id=>nil)
    @painting = Painting.new
    @tour = Tour.new
     @selected_pkgs=selected_pkgs_without_tour
  end

  def create
    @painting = Painting.create(params[:painting])
    @painting.user_id= current_user.id
    @painting.save
#    puts "***********************"
#    p @painting
#
#    $ids << @painting.id
#    session[:painting] = $ids
#    puts "**********************"
#
#    puts "*****************session******"
#    p session[:painting].flatten()
#  puts "***********************"
 #p session[:painting]=nil
  end

  def edit
    @painting = Painting.find(params[:id])
  end

  def update
    @painting = Painting.find(params[:id])
    if @painting.update_attributes(params[:painting])
      redirect_to :back, :notice=> "Image was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @painting = Painting.find(params[:id])
    if @painting.destroy
      redirect_to :back
     # redirect_to paintings_url, :notice=> "Image was successfully deleted."
    end
  end

  private
  def selected_pkgs_without_tour
   pkgs= current_user.selected_packages.select do|spkg|
        
      spkg if spkg.tour.nil?
      
    end
    return pkgs
  end
end
