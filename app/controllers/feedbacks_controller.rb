class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all
  end
  def new
    #@feedback = Feedback.new
  end
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.user_id = current_user.id
    if @feedback.save
      flash[:notice] = "Thanks for your feedback. We look forward to serve better!" 
    else
      flash[:error] = "Sorry, Your feedback has not been submitted. kindly, try again later."
    end
     redirect_to :back
  end
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
  end
end
