VirtualTour::Application.routes.draw do
  match '/payments/payment', :to => 'payments#payment', :as => 'paymentspayment', :via => [:get]
 match 'payments/save_user', :to=>'payments#save_user', :as=>'payments_save_user' ,:via=>[:get]
  match '/payments/thank_you', :to => 'payments#thank_you', :as => 'payments_thank_you', :via => [:get]
  match '/payments/renew_successfull', :to => 'payments#renew_successfull', :as => 'payments_renew_successfull', :via => [:get]
  match '/packages/upgrade', :to => 'packages#upgrade', :as => 'upgrade_packages', :via => [:get]
  match '/packages/upgrade_combo', :to => 'packages#upgrade_combo', :as => 'upgrade_combo_packages', :via => [:get]

  #get "home/index"
  get "packages/show"
  match '/tours/view_map' => 'tours#view_map'
  match '/tours/status_change' => 'tours#status_change'
  match '/tours/update' => 'tours#update'
  match '/tours/user_tours'=>'tours#user_tours'
  match '/paintings/set_name'=>'paintings#set_name'
  match '/paintings/update_priority'=>'paintings#update_priority'
  match '/paintings/check_name_of_pictures'=>'paintings#check_name_of_pictures'
  match '/tours/find_tours' => 'tours#find_tours'
  match '/paintings/count_rooms'=>'paintings#count_rooms'
  match '/tours/sold_out_tours' => 'tours#sold_out_tours'
  match '/tours/find_map_tours' => 'tours#find_map_tours'
 
  # match '/paintings/create_ie'=>'paintings#create_ie'


  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users,:controllers => { :registrations => "Registrations" }
  resources :paintings
  resources :tours
devise_scope :user do
   #get "registrations/text_visit" => "registrations#text_visit"
  match "registrations/save_user" => "registrations#save_user"
end


  resources :feedbacks, :except => [:edit, :update]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 
  root :to => 'home#index'
  ActiveAdmin.routes(self)
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
