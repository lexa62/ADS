Rails.application.routes.draw do

  root 'ads#index'
  devise_for :users
  resources :ads

  get '/my_ads' => 'dashboard#ads', :as => :my_ads
  get 'ads/:id/moderating' => 'ads#moderating', :as => :ads_moderating
  get 'ads/:id/make_draft' => 'ads#make_draft', :as => :ads_make_draft
  get 'ads/:id/edit_rejected' => 'ads#edit_rejected_ad', :as => :ads_edit_rejected
  get 'ads/:id/approve' => 'ads#approve_ad', :as => :ads_approving
  get 'ads/:id/ban' => 'ads#ban_ad', :as => :ads_rejecting
  post 'ads/approving' => 'ads#approve_ads', :as => :approve_multiple_ads

  namespace :admin do
    resources :ads, :only => [:index, :show]
    resources :users
    resources :ad_types, :only => [:index, :new, :create, :destroy]
  end
end
