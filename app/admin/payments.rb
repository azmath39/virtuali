ActiveAdmin.register Payment do
  config.clear_action_items!
  #actions :index, :show
   menu :priority => 6
   config.per_page = 10

#scope Product::all_label do |payments|
#  payments
#end
scope :all
Product.all.each do |product|
  scope product.name do |payments|
    payments.where("product_id = ?", product.id)
  end
end
  index do
    column "Transaction Date", :created_at
    column  "Transaction Reference",:reference
    column "Full Name",:name
    column :product
    column "Email", :email

    column "Transaction Type",:payment_type_info,:sortable=>false
    column :amount, :sortable =>:amount do |product|
      number_to_currency product.amount, :unit => "$ "
    end
    


    default_actions
  end
# member_action :totals do
##      @post = Post.find(params[:id])
##      @page_title = "#{@post.title}: Comments" # Set the page title
#
#      # This will render app/views/admin/posts/comments.html.erb
#    end
  

end
