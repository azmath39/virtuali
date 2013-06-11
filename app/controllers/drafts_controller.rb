class DraftsController < ApplicationController

  def new
  end


  def edit
    @draft=Draft.find(params[:id])
    @paintings=@draft.paintings
    @painting=Painting.new
    @products = current_user.subscribe_product
    @cities=[]
    state=State.find_by_name(@draft.state)
    @cities= City.find(:all,:conditions=>{:code=>state.code}) unless state.nil?
    if session[:cancel_request].nil? and !params.include?:cancel_request
      Painting.destroy_all(:user_id=>current_user.id,:tour_id=>nil,:draft_id=>nil)
    elsif !session[:cancel_request].nil?
      session[:cancel_request]=nil
    end
    @paintings += Painting.where(:user_id=>current_user.id,:tour_id=>nil,:draft_id=>nil)
    @paintings.flatten!
    @paintings=@paintings.sort_by &:priority
    @priority=get_priority
  end
  def update
    unless params.include?:tour
      tour_creation
    else
      saved_to_draft
    end
  end

  def show
  end

  def index
    @drafts=current_user.drafts.order('updated_at DESC')
  end
  private
  def tour_creation
    @tour = Tour.new(params[:draft])
    if @tour.save
      current_user.tours << @tour
      #NotificationsMailer.tour_created_message(current_user, @tour).deliver
      @paintings=current_user.paintings.where(:tour_id => nil,:draft_id =>[nil,params[:draft][:id]])
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
  def saved_to_draft
    @draft = Draft.find(params[:id])
    @draft.update_attributes(params[:draft])

    current_user.paintings.where(:tour_id => nil,:draft_id => nil).each do |pic|
      @draft.paintings << pic
    end

    flash[:notice] = "Sucessfully saved to draft."
    #redirect_to :controller => 'tours', :action => 'final_tour', :id => @tour.id
    redirect_to drafts_url
  end
  def get_priority
    priority=@draft.paintings.maximum(:priority)
    priority += 1 unless priority.nil?
  end
end
