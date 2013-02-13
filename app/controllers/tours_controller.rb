class ToursController < ApplicationController
  def index
    @tours = current_user.tours.paginate(:page => params[:page], :per_page => 2)
  end
  def show
    @tour = Tour.find(params[:id])
  end
  def new
    @tour = Tour.new
  end
  def create
    @tour = Tour.new(params[:tour])
    if @tour.save
      current_user.tours << @tour
        session[:painting].each do |id|
        @painting = Painting.find_by_id(id)
        @painting.tour_id = @tour.id
        @painting.save
        end
        $ids = []
        session[:painting] = nil
        #session.delete(:painting)
        #session[:painting]=nil
        #session.data.delete :painting
        flash[:notice] = "Tour was created successfully."
        redirect_to :controller => 'tours', :action => 'final_tour'
      else
        render 'new'
      end
      
  end
  def edit
    @tour = Tour.find(params[:id])
  end
  def update
    @tour = Tour.find(params[:tour][:id])
    if @tour.update_attributes(params[:tour])
      flash[:notice] = 'Tour updated successfully.'
      redirect_to :action => 'index'
    else
      render 'edit'
    end
  end
  def destroy
    @tour = Tour.find(params[:id])
    if @tour.destroy
      flash[:notice] = "Tour was deleted."
      redirect_to :action => 'index'
    else
      flash[:error] = "Tour can't be deleted."
      redirect_to :action => 'index'
    end
  end
  def final_tour
    @tour = current_user.tours.last
  end
  def slide_show
    @tour = Tour.find(params[:id])
  end
  def view_map
    @tours = Tour.all
    @json = @tours.to_gmaps4rails do |tour, marker|
      marker.infowindow("#{tour.name}<br />" "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
      marker.title("#{tour.city}")
    end
  end
end
