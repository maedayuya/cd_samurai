Rails.application.routes.draw do

  root 'home#top'
  get 'after_login_to_post', to: 'home#after_login_to_post'
  get '/admins', to: 'admins/products#index'

  # エンドユーザ側
  devise_for :users
  resources :users do
  	get 'withdrawal', on: :member
  	get 'ordered', on: :collection
  end
# 住所
  resources :addresses
# 商品
  resources :orders, only: [:new,:show,:create] do
    post :confirm, action: :confirm, on: :new
    resources :order_products, only: [:new,:show,:create]
  end
  #cart情報
  resources :products do
    resource :carts, only: [:create]
  end
  match 'carts/all' => 'carts#update_all', :as => :update_all, :via => :put
  resources :carts, only: [:index,:destroy,:create]

# 管理者側
  devise_for :admins, controllers: {
    :sessions => 'admins/sessions'
}
  match 'admins/all' => 'admins/orders#update_all', :as => :admins_update_all, :via => :put
  namespace :admins do
   resources :products
   resources :orders
   resources :addresses
   resources :users do
     get 'withdrawal', on: :member
   end
  # ジャンル情報
   resources :genres, only: [:index,:create,:destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

