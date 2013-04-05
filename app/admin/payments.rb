ActiveAdmin.register Payment do
  config.clear_action_items!
  #actions :index, :show
   menu :priority => 6
   config.per_page = 10


Product.all.each do |product|
  scope product.name_label do |payments|
    payments.where("product_id = ?", product.id)
  end
end
  index do
    column "Transaction Date", :created_at
    column  "Transaction Reference",:reference
    column "user name",:name
    column :product
    column "user email", :email

    column "Transaction Type",:payment_type_info
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
