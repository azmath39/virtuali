ActiveAdmin.register User do
 config.clear_action_items!
     member_action :status do

     @users = User.all
     @tours = Tour.all
     @payments = Payment.find(:all,:order=>'created_at DESC')
      #@u = User.find(params[:id])
      @app_size= User::appliction_size
      # This will render app/views/admin/posts/comments.html.erb
    end
     
   menu :label => "Status Report" ,:url=> '/admin/users/status/status'
   
end
