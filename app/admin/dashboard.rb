ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  #config.per_page = 10
  content :title => proc{ I18n.t("active_admin.dashboard") } do
   
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
        panel "Space Usage" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              " #{User::appliction_size}MB."
            end
          end
        end
      end
      column do
        panel "Total Number Coupon Used " do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to(CouponTransaction.count,admin_coupon_transactions_path)
            end
          end
        end
      end
      column do
        panel "Payment" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
               link_to(Payment.sum(:amount),admin_payments_path)
             
            end
          end
        end
      end
       
      column do
        panel "Number of Tours Active" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
               link_to(Tour.active.count,admin_tours_path)

            end
            
          end
        end
      end
      column do
        panel "Number of Tours Inactive" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
               link_to(Tour.inactive.count,admin_tours_path)

            end

          end
        end
      end
      column do
        panel "Number of Tours Sold" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
               link_to(Tour.sold.count,admin_tours_path)

            end

          end
        end
      end
      
      
    end
    columns do
      column do
        panel "Recent Payments" do
          ul do
            Payment.recent.map do |payment|
              li link_to("#{payment.payment_type_info} #{payment.amount}", admin_payment_path(payment))
            end
          end
        end
      end
      column do
        panel "Recent Signup Users" do
          ul do
            User.recent.map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end
       

      column do
        panel "Recent Feedbacks" do
          ul do
#                      Feedbacks.recent.map do |feed|
#                        li  link_to("#{feed.user_name} #{feed.satisfaction_status}", admin_user_path(feed))
#                      end
          end
        end
      end
    end

  end # content
end
