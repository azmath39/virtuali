ActiveAdmin.register User do

     member_action :status do

     @users = User.all
    @tours = Tour.all
    @payments = Payment.all
      #@u = User.find(params[:id])

      # This will render app/views/admin/posts/comments.html.erb
    end
    
end
