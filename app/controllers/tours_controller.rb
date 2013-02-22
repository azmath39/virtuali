class ToursController < ApplicationController
  def index
    if signed_in?
      @tours = current_user.tours.paginate(:page => params[:page], :per_page => 5)
    else
      @search = Tour.search(params[:q])
      if params[:q].nil?
        #@tours = Tour.all
        @tours = Tour.paginate(:page => params[:page], :per_page => 5)
      else
        @tours = @search.result.paginate(:page => params[:page], :per_page => 5)
        
      end
    end
  end
  def show
    @tour = Tour.find(params[:id])
    if request.path != tour_path(@tour)
      redirect_to @tour, status: :moved_permanently
    end
  end
  def new
    @tour = Tour.new
    @selected_pkgs=selected_pkgs_without_tour
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
        redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
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
    @gmapsoptions = {
     "map_options" => {"center_latitude" => 0,
                       "center_longitude" => 0,
                       "detect_location" => true,
                       "center_on_user" => true,
                       "auto_adjust" => true,
                       "auto_zoom" => true,
                       "zoom" => 20 }
                 }
    if signed_in?
      @current_user_tours = current_user.tours
      @json = @current_user_tours.to_gmaps4rails do |tour, marker|
        marker.infowindow("#{tour.name}<br />" "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
        marker.title("#{tour.city}")
      end
    else
      @all_tours = Tour.all
      @json = @all_tours.to_gmaps4rails do |tour, marker|
        marker.infowindow("#{tour.name}<br />" "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
        marker.title("#{tour.city}")
      end
    end
    @us_states= ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District Of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
  end
  def status_change
    tour = Tour.find(params[:id].to_i)
    tour.update_attributes(:status=>params[:status].to_i)
    render :text=>tour.tour_status
  end

  private
  def selected_pkgs_without_tour
    current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
  end
end
