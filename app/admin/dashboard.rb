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
            span :class => "blank_slate",:style=>"width:105px !important;margin-left:-10%; color:black;" do
              " #{SpaceUsage::remaining_space}."
            end
          end
        end
      end
      column do
        panel "Total User" do

          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to(User.count,admin_users_path)
            end
          end


        end
      end
      column do
        panel "Promotions" do

          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to(CouponTransaction.count,admin_promotion_transactions_path)
            end
          end
        end
      end
      column do
        panel "Total Payment" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to("$ #{Payment.sum(:amount)}", admin_payments_path)
            end
          end
        end
      end

      column do
        panel "Total Tours" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to(Tour.count,admin_tours_path)

            end

          end
        end
      end
      column do
        panel "Total Tours Active" do
          div :class => "blank_slate_container", :id => "dashboard_default_message" do
            span :class => "blank_slate" do
              link_to(Tour.active.count,admin_tours_path)
      
            end
      
          end
        end
      end
      column do
        panel "Total House Sold" do
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
        panel "Report" do
          table_for Product.all,:class=>"index_table index" do |t|
            t.column("name"){|product|product.name}
            t.column("Users"){|product|product.users_count}
            t.column("subscription"){|product|product.subscriptions}
            t.column("Promoted subscription"){|product|product.promoted_subscriptions}
            t.column("payment"){|product|product.sum_payments}
            t.column("House sold"){|product|product.tours.sold.count}
            t.column("total tours"){|product|product.tours.count}
            t.column("tours active"){|product|product.tours.active.count}
            t.column("tours inactive"){|product|product.tours.inactive.count}
    
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
            Feedback.recent.map do |feed|
              li  link_to("#{feed.user_name} : #{feed.opinion}", admin_feedback_path(feed))
            end
          end
        end
      end
    end

  end # content
end
