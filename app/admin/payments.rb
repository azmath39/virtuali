ActiveAdmin.register Payment do
  config.clear_action_items!
  actions :index, :show
   #menu :priority => 6,:url=>'/admin/payments/totals/totals'
   menu :priority => 6
   config.per_page = 10


#scope :all
#Product.all.each do |product|
#  scope product.name do |payments|
#    payments.where("product_id = ?", product.id)
#  end
#end

  index do
     amount = 0
  
    column "Transaction Date", :created_at
    column  "Transaction Reference",:reference
    column "Full Name",:name
    column :product
    column "Email", :email

    column "Transaction Type",:payment_type_info,:sortable=>false
#    column :amount, :sortable =>:amount do |product|
#      number_to_currency product.amount, :unit => "$ "
#    end
    column("amount") {|resource| amount = amount + resource.amount;resource.amount}
    default_actions
   

    span  :class=>'total' do
        "Total: $ #{amount}"
    end
# columns do
#      column do
#        panel "Space Usage" do
#
#            span :class => "blank_slate",:style=>" color:black;" do
#              " #{Payment.sum(:amount)}."
#            end
#          end
#
#      end
#      column do
#        panel "Total Payment" do
#
#            span :class => "blank_slate" do
#              link_to("$ #{Payment.sum(:amount)}", admin_payments_path)
#            end
#
#        end
#      end
# end
  end
  
# member_action :totals do
#@payments = Payment.find(:all,:order=>'created_at DESC')
#    end
#
#def index
#end
end
