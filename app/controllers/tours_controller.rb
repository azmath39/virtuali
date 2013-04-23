class ToursController < ApplicationController
  before_filter :verify_account_validity, :only=>["edit","user_tours"]
  def index
    #@search = Tour.where(:status => (0..1)).search(params[:q])
    if params[:q].nil?
      @search = Tour.active.search(params[:q])
      @tours = Tour.active.tours_list_pagination(params[:page])
    elsif params[:q][:status_eq] == "3"
      @search = Tour.sold.search(params[:q])
      @tours = @search.result.tours_list_pagination(params[:page])
    else
      @search = Tour.active.search(params[:q])
      @tours = @search.result.tours_list_pagination(params[:page])
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
      #NotificationsMailer.tour_created_message(current_user, @tour).deliver
      @paintings=current_user.paintings.where(:tour_id => nil)
      @paintings.each do |pic|
        @tour.paintings << pic
      end 
      flash[:notice] = "Tour was created successfully."
      #redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
      redirect_to tour_path(@tour)
    else
      error_to_flash
      redirect_to :action=>'new', :controller=>"paintings"
    end
  end
  def edit
    @tour = current_user.tours.find(params[:id].to_i)
    @paintings = Painting.where(:user_id=>current_user.id,:tour_id=>@tour.id).order('created_at ASC')
    @count=@paintings.count unless @paintings.nil?
    @paintings << Painting.where(:user_id=>current_user.id,:tour_id=>nil)
    @paintings.flatten!
    @painting = Painting.new
    @products = current_user.subscribe_product
    state=State.find_by_name(@tour.state)
    @cities= City.find(:all,:conditions=>{:code=>state.code})
  end
  def update
    @tour = current_user.tours.find(params[:tour][:id])
    if @tour.update_attributes(params[:tour])
      @paintings=current_user.paintings.where(:tour_id=>nil)
      @paintings.each do |pic|
        @tour.paintings<<pic
      end unless @paintings.empty?
      flash[:notice] = 'Tour updated successfully.'
      #redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
      redirect_to tour_path(@tour)
    else
      error_to_flash
      redirect_to edit_tour_path(@tour)
    end
  end
  def destroy
    @tour = current_user.tours.find(params[:id])
    if @tour.destroy
      flash[:notice] = "Tour was deleted."
      redirect_to :action => 'index',:controller=>"home"
    else
      flash[:error] = "Tour can't be deleted."
      redirect_to :action => 'index',:controller=>"home"
    end
  end
  def final_tour
    @tour = Tour.find(params[:id])
  end
  def slide_show
    @tour = Tour.find_by_slug(params[:id])
  end
  def view_map
    #      if params.has_key? "map_product"
    #        if params["map_product"] == ""
    #          @tours = Tour.all
    #        else
    #        @tours = []
    #        @products=SelectedProduct.find(:all,:conditions=>{:product_id=>params[:map_product].to_i})
    #        @products.each do |product|
    #          @tours << product.user.tours.where(:status => 1)
    #        end
    #        end
    #        @tours.compact!
    #        @tours.flatten!
    #      elsif params.has_key? "status"
    #        @tours = Tour.where(:status => params[:status].to_i)
    #      else
    #        @tours = Tour.active
    #      end
    @search = Tour.search(params[:q])
    if !params[:q].nil?
      @tours = @search.result
    else
      @tours = Tour.active
    end
    if @tours.empty?
      flash.now[:notice] = "No tours were found!"
    end
    @json = @tours.to_gmaps4rails do |tour, marker|
      marker.infowindow("<center><img src=\"#{tour.paintings.compact.first.image.url(:thumb)}\" width=\"150\" height=\"100\"><br />
                         <b>#{tour.zip} #{tour.state} #{tour.city}</b><br />
                         " "Beds:#{tour.bed_rooms}/Baths: #{tour.bath_rooms}<br />
                          Category: #{tour.product.name}<hr>
                          " "<a href='http://#{request.host_with_port}/tours/show/#{tour.id}' target = \"_blank\">Click for Tour</a>".html_safe)
      marker.title("#{tour.city}")
    end
  end
  def status_change
    tour = Tour.find(params[:id].to_i)
    if tour.status == 2
      current_user.enable_tour
    else
      tour.update_attributes(:status=>params[:status].to_i)
    end
    render :text=>tour.tour_status
  end
    
  def user_tours
    if signed_in?
      if params.include?:product_id and !params[:product_id].empty?
        @tours = current_user.tours.where(:product_id=>params[:product_id].to_i).order('created_at DESC')
      else
        @tours = current_user.tours.order('created_at DESC')
      end
      render :partial=>'list_of_tours'
    end
  end

  def download_zip
    @tour = Tour.find(params[:id])
    image_list = @tour.paintings
    if !image_list.blank?
      file_name = "#{@tour.user.name}_tour_pictures_#{@tour.created_at.strftime("%d-%b-%Y_%H:%M")}.zip"
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      i = 1
      Zip::ZipOutputStream.open(t.path) do |z|
        image_list.each do |img|
          title = "#{i}_#{img.name||"unknown"}.#{img.image.file.extension}"
          image_url = "#{Rails.root.to_s}/public#{img.image.url(:large)}"
          #title += ".jpg" unless title.end_with?(".jpg")
          z.put_next_entry(title)
          z.print IO.read(image_url)
          i += 1
        end
      end
      send_file t.path, :type => 'application/zip',
        :disposition => 'attachment',
        :filename => file_name
      t.close
    else
      flash[:error] = "Sorry, No images were found for this tour!"
      redirect_to :back
    end
  end
  def find_tours
    @tours = []
    @products=SelectedProduct.find(:all,:conditions=>{:product_id=>params[:id].to_i})
    @products.each do |product|
      @tours << product.user.tours.where(:status => (0..1)).order('created_at DESC')
    end
    if params[:id] == ""
      @tours = Tour.where(:status => (0..1))
    end
    @tours.compact!
    @tours.flatten!
    render :partial => 'all_tours'
  end
  
  def sold_out_tours
    @tours = Tour.where(:status => params[:status].to_i).order('created_at DESC')
    render :partial => 'all_tours'
  end
 
  private
  def selected_pkgs_without_tour
    current_user.selected_packages.select do|spkg|
      spkg unless spkg.tour.nil?
    end
  end
  def error_to_flash
    flash[:error] ||= []
    @tour.errors.full_messages.each do |x|
      if x == "Gmaps4rails address Address invalid"
        x = "Not a Valid Address"
      end
      flash[:error]<< x
    end

  end
end
 