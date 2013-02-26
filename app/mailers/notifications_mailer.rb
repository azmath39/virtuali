class NotificationsMailer < ActionMailer::Base
  default :from => "git.venkat@gmail.com"
  #default :to => "venky541@gmail.com"

  def new_message(message)
    @message = message
    mail(:to => $receiver_email, :subject => "[VirtualI Test] #{message.subject}")
  end
end
