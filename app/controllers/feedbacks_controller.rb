class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all
  end
  def new
    @feedback = Feedback.new
  end
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.user_id = current_user.id
    if @feedback.save
      flash[:success] = "Thanks for your feedback. We look forward to serve better!"
      redirect_to root_path
    end
  end
  def destroy
    @feedback = Feedback.find(params[:id])
    if @feedback.destroy
      render :text => "Feedback destroyed!"
    end
  end
end
