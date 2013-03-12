  ActiveAdmin.register Feedback do
    member_action :feedback do
      @feedbacks = Feedback.all
    end
    menu :priority => 20, :url => '/admin/feedbacks/feedback/feedback'
    
  end