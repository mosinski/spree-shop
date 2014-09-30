Rails.application.routes.draw do
  get '/cart', to: 'orders#cart', as: :cart
  get '/cart/add-item/:variant_id', to: 'orders#add_item_cart', as: :add_item_cart
  post '/cart/add-item', to: 'orders#add_item_cart', as: :add_item_cart_post
  patch '/cart', to: 'orders#update_cart', as: :update_cart
  get '/cart', to: 'orders#change_quantity', as: :change_quantity_cart
  get '/checkout', to: 'orders#checkout', as: :checkout

  root to: "pages#home"
  mount Spree::Core::Engine, at: '/'

  resources :products
  devise_for :users, controllers: {registrations: 'registrations', sessions: 'sessions'}
  devise_scope :user do
    get '/login', to: "devise/sessions#new"
    delete '/logout', to: "devise/sessions#destroy"
  end

  get '/contact' => "pages#contact"
end
