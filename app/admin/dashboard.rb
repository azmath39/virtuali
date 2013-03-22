ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        "Space Used :#{User::appliction_size}MB."
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    
        
      
     columns do
       column do
        panel "Recent Users" do
           ul do
            User.all.map do |tour|
              li link_to(tour.name, admin_user_path(tour))
            end
          end
        end
      end

       column do
         panel "Recent Feedbacks" do
           ul do
#            Feedbacks.all.map do |tour|
#              li link_to(tour.name, admin_user_path(tour))
#            end
          end
        end
      end
    end

  end # content
end
