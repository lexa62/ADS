Rails.application.routes.draw do

  root 'ads#index'
  devise_for :users
  resources :ads do
    post 'approving' => 'ads#approve_ads', on: :collection

    member do
      get 'approve' => 'ads#approve_ad'
      get 'edit_rejected' => 'ads#edit_rejected_ad'
      get 'make_draft'
      get 'moderating'
      get 'reject' => 'ads#reject_ad'
    end
  end

  get '/my_ads' => 'dashboard#ads', :as => :my_ads

  namespace :admin do
    resources :ads, :only => [:index, :show]
    resources :ad_types, :only => [:index, :new, :create, :destroy]
    resources :users
  end
end
