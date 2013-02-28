class NotificationsMailer < ActionMailer::Base
  default :from => "git.venkat@gmail.com"
  #default :to => "venky541@gmail.com"

  def new_message(message)
    @message = message
    mail(:to => $receiver_email, :subject => "[VirtualI Test] #{message.subject}")
  end
  def tour_created_message(user, tour)
    @user = user
    @tour = tour
    mail(:to => @user.email, :subject => "Tour Creation Message!")
  end
end
