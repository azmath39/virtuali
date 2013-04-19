class ContactController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    tour=Tour.find_by_id(params[:tour_id])
    $receiver_email = tour.user.email
    if @message.save
      tour.messages << @message
      NotificationsMailer.new_message(@message).deliver
      flash[:notice] = "Message sent successfully!"
      redirect_to :back
    else
      flash.now.alert = "Please fill all fields."
      redirect_to :back
    end
  end
end
