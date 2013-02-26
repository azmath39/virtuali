class ContactController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    $receiver_email = Tour.find_by_id(params[:tour_id]).user.email
    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
        
      redirect_to(tours_path, :notice => "Message was successfully sent!")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end
end
