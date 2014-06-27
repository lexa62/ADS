Rails.application.routes.draw do

  root 'ads#index'
  devise_for :users
  resources :ads
  
  get '/my_ads' => 'ads#users_ads', :as => :my_ads
  get 'moderating/:id' => 'ads#moderating', :as => :ads_moderating
  get 'make_draft/:id' => 'ads#make_draft', :as => :ads_make_draft
  get 'edit_rejected/:id' => 'ads#edit_rejected_ad', :as => :ads_edit_rejected

  scope "/admin" do
    get '/' => 'admin#index', :as => :admin
    get '/approve/:id' => 'admin#approve_ad', :as => :ads_approving
    post '/approve' => 'admin#approve_ads', :as => :approve_multiple_ads
    get '/ban/:id' => 'admin#ban_ad', :as => :ads_rejecting
    get '/ad_types' => 'admin#ad_types', :as => :ad_types
    get '/users' => 'admin#users', :as => :users
    resources :users
    resources :ad_types, :only => [:new, :create, :destroy]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
