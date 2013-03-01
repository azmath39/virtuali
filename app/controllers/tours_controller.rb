class ToursController < ApplicationController
  def index
      @search = Tour.where(:status => (0..1)).search(params[:q])
      if params[:q].nil?
        @tours = Tour.where(:status => (0..1)).paginate(:page => params[:page], :per_page => 3)
      else
        @tours = @search.result.paginate(:page => params[:page], :per_page => 5)
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
      NotificationsMailer.tour_created_message(current_user, @tour).deliver
      @paintings=current_user.paintings.where(:tour_id => nil)
      @paintings.each do |pic|
        @tour.paintings<<pic
      end unless @paintings.empty?
        flash[:notice] = "Tour was created successfully."
        redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
      else
        render 'paintings/new'
      end
  end
  def edit
    @tour = Tour.find(params[:id])
    @paintings = Painting.where(:user_id=>current_user.id,:tour_id=>@tour.id  )
    @count=@paintings.count unless @paintings.nil?
    @paintings << Painting.where(:user_id=>current_user.id,:tour_id=>nil)
    @paintings.flatten!
    @painting = Painting.new
  end
  def update
    @tour = Tour.find(params[:tour][:id])
    if @tour.update_attributes(params[:tour])
      @paintings=current_user.paintings.where(:tour_id=>nil)
      @paintings.each do |pic|
        @tour.paintings<<pic
      end unless @paintings.empty?
      flash.now[:notice] = 'Tour updated successfully.'
       redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
    else
      flash.now[:error] = 'Sorry,Unable to update Tour.'
      edit
      render 'edit'
    end
  end
  def destroy
    @tour = Tour.find(params[:id])
    if @tour.destroy
      flash[:notice] = "Tour was deleted."
      redirect_to :action => 'index',:controller=>"home"
    else
      flash[:error] = "Tour can't be deleted."
      redirect_to :action => 'index',:controller=>"home"
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
      "map_options" => {"center_latitude" => 0, "center_longitude" => 0, "detect_location" => true, "center_on_user" => true,
        "auto_adjust" => true,
        "auto_zoom" => true,
        "zoom" => 20 }
    }
    @search = Tour.search(params[:q])
    if params.has_key? :id
      @tours = []
      @p = Product.find_by_id(params[:id])
      @p.packages.each do |pkg|
        pkg.selected_packages.each do |sel_pkg|
          @tours << sel_pkg.tour
        end
      end

      if @tours.empty?
        flash.now[:notice] = "No tours were found!"
      end
      @tours.compact!
       @json = @tours.to_gmaps4rails do |tour, marker|

        marker.infowindow("#{tour.name}<br />" "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
        marker.title("#{tour.city}")
       end
    else

        @tours = Tour.all
        if !params[:q].nil?
         @tours = @search.result
        end
        @json = @tours.to_gmaps4rails do |tour, marker|
        marker.infowindow("#{tour.name}<br />" "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
        marker.title("#{tour.city}")
      end
    end

  end
  def status_change
    tour = Tour.find(params[:id].to_i)
    tour.update_attributes(:status=>params[:status].to_i)
    render :text=>tour.tour_status
  end
  def user_tours
    if signed_in?
      @tours = current_user.tours
    render :partial=>'list_of_tours'
    end
  end

  private
  def selected_pkgs_without_tour
    current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
  end
end
