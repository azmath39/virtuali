ActiveAdmin.register SpaceUsage do
  menu :label=>"Sever Size",:parent => "Admin Options"
  config.clear_action_items!
   form do |f|
    f.inputs "SpaceUsage Details" do
      f.input "size", :label =>"Size (in MB)"

      end
    f.actions
  end
  index do
    column "DateTime", :created_at
    column "Server Size", :size
    default_actions
  end
end
