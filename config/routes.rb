Rails.application.routes.draw do
  get '/cart', to: 'orders#cart', as: :cart
  get '/cart/add-item/:variant_id', to: 'orders#add_item_cart', as: :add_item_cart
  post '/cart/add-item', to: 'orders#add_item_cart', as: :add_item_cart_post
  get '/cart/remove-item/:variant_id', to: 'orders#remove_item_cart', as: :remove_item_cart
  patch '/cart', to: 'orders#update_cart', as: :update_cart
  get '/checkout', to: 'orders#checkout', as: :checkout
  patch '/checkout/:state', :to => 'orders#update_checkout', :as => :update_checkout
  get '/checkout/:state', :to => 'orders#checkout', :as => :checkout_state

  root to: "pages#home"
  mount Spree::Core::Engine, at: '/'

  resources :products
  devise_for :users, controllers: {registrations: 'registrations', sessions: 'sessions'}

  get '/contact' => "pages#contact"
end
