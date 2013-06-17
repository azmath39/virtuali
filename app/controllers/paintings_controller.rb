class PaintingsController < ApplicationController
  before_filter :verify_account_validity, :only=>["new"]
  # before_filter :set_default_response_format


  def index
    #@painting = Painting.new
    @paintings = Painting.all
  end

  def show
    @painting = Painting.find(params[:id])
  end
  
  def new 
    #render :layout => false
    @paintings = Painting.where(:user_id=>current_user.id,:tour_id=>nil,:draft_id=>nil).order('priority ASC')

    @painting = Painting.new
    @tour = Tour.new
    @products = current_user.subscribe_product
    @priority=get_priority
   
    
    if session[:cancel_request].nil? and !params.include?:cancel_request
      Painting.destroy_all(:user_id=>current_user.id,:tour_id=>nil,:draft_id=>nil)
    elsif !session[:cancel_request].nil?
      session[:cancel_request]=nil

    end
    #    respond_to do |format|
    #    format.js {render :layout=>false}
    #  end
    # @selected_pkgs=selected_pkgs_without_tour
  end

  def create
    @previous_count=params[:count] if params.include?"count"
    if verify_no_image then
      @painting = Painting.new(params[:painting])
      @painting.user_id= current_user.id
      puts "painitng/.............!"
      if @painting.save
        respond_to do |format|
          format.html do
            session[:cancel_request]=1
            if browser.ie9?
             render :js=>"window.location.reload(true);"
            else
            redirect_to :back
            end
          end
          format.js
        end
      else

        render :js=>"alert(#{@painting.errors[:image]})"
      end
     
    end
  end

  def edit
    @painting = Painting.find(params[:id])
  end

  def update
    @painting = Painting.find(params[:painting][:id].to_i)
    if @painting.update_attributes(params[:painting])
      #      redirect_to :back, :notice=> "Image was successfully updated."
      flash[:success] = "Image was updated!"
      redirect_to :back
    else
      render :edit
    end
  end

  def destroy
    @painting = current_user.paintings.find(params[:id])
    if @painting.destroy
      render :nothing=>true
      #redirect_to :back
      # redirect_to paintings_url, :notice=> "Image was successfully deleted."
    end
  end
  def update_priority

    target= current_user.paintings.find(params[:id])
    target_priority=target.priority
    if params.include?"tour_id"
      other= (current_user.paintings.where(:priority=>params[:value],:tour_id=>params[:tour_id])+current_user.paintings.where(:priority=>params[:value],:tour_id=>nil,:draft_id=>nil)).compact.last
    elsif params.include? "draft_id"
      other= (current_user.paintings.where(:priority=>params[:value],:draft_id=>params[:draft_id])+current_user.paintings.where(:priority=>params[:value],:tour_id=>nil,:draft_id=>nil)).compact.last

    else
      other= current_user.paintings.where(:priority=>params[:value],:tour_id=>nil, :draft_id=>nil).last
    end


    target.update_attributes(:priority=>params[:value])
    unless other.nil?
      other.update_attributes(:priority=>target_priority)
      render :text=> "#{other.id},#{target_priority}"
    else
      render :nothing=>true
    end



  end
  
  
  def set_main_image_true
    #true or false when checking main tour images
    p =Painting.find(params[:id])
    if params[:state]=="true"
      p.update_attributes(:select_image=>true)
      
    else 
      p.update_attributes(:select_image=>false)
    end
  end
  
  
  def set_name
    painting= Painting.find(params[:id])
    painting.update_attributes(:name=>params[:name])
    if params.include?"tour_id"
      bedroom=current_user.paintings.where(:tour_id=>params[:tour_id].to_i,:name=>"Bed Room").count + current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bed Room").count
      bathroom=current_user.paintings.where(:tour_id=>params[:tour_id].to_i,:name=>"Bath Room").count + current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bath Room").count
      str = "#{bedroom},#{bathroom}"
    elsif params.include?"draft_id"
      str = "#{current_user.paintings.where(:draft_id=>[params[:draft_id].to_i,nil],:tour_id=>nil,:name=>"Bed Room").count}, #{current_user.paintings.where(:draft_id=>[params[:draft_id].to_i,nil],:tour_id=>nil,:name=>"Bath Room").count}"
    else
      str = "#{current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bed Room").count}, #{current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bath Room").count}"
    end
    render :text=>str
  end
  def count_rooms
    if params.include?"tour_id"
      bedroom=current_user.paintings.where(:tour_id=>params[:tour_id].to_i,:name=>"Bed Room").count + current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bed Room").count
      bathroom=current_user.paintings.where(:tour_id=>params[:tour_id].to_i,:name=>"Bath Room").count + current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bath Room").count
      str = "#{bedroom},#{bathroom}"
    elsif params.include?"draft_id"
      str = "#{current_user.paintings.where(:draft_id=>[params[:draft_id].to_i,nil],:tour_id=>nil,:name=>"Bed Room").count}, #{current_user.paintings.where(:draft_id=>[params[:draft_id].to_i,nil],:tour_id=>nil,:name=>"Bath Room").count}"
    else
      str = "#{current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bed Room").count}, #{current_user.paintings.where(:tour_id=>nil,:draft_id=>nil,:name=>"Bath Room").count}"
    end
    render :text=>str
  end
  def check_name_of_pictures
    unless current_user.check_name_of_pictures?
      render :text=>"1"
    else
      render :text=>"0"

    end
  end
  

  private
  #  def selected_pkgs_without_tour
  #   pkgs= current_user.selected_packages.select do|spkg|
  #
  #      spkg if spkg.tour.nil?
  #
  #    end
  #    return pkgs
  #  end
  def verify_no_image
    existing_images=0
    current_nil_image=current_user.paintings.where(:tour_id=>nil)
    limit = current_user.selected_package.pictures_for_tour
    existing_images+=@previous_count.to_i unless @previous_count.nil?
    existing_images += current_nil_image.count unless current_nil_image.nil?
    if existing_images< limit
      return true
    else
      return false
    end
  end
  private
  def get_priority
    priority=current_user.paintings.where(:tour_id=>nil,:draft_id=>nil).maximum(:priority)
    priority += 1 unless priority.nil?
  end

  #  def set_default_response_format
  #      #request.format = 'js'.to_sym
  #      #
  #    end
end
