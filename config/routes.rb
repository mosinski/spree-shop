Rails.application.routes.draw do
  get '/cart', :to => 'orders#cart', as: :cart
  get '/cart/add-product/:id', :to => 'orders#put_to_cart', as: :put_to_cart
  get '/cart/remove-product/:id', :to => 'orders#remove_from_cart', as: :remove_from_cart
  get '/cart', :to => 'orders#change_quantity', as: :change_quantity_cart
  get '/checkout', to: 'orders#checkout', as: :checkout

  root to: "pages#home"
  mount Spree::Core::Engine, :at => '/'

  resources :products
  devise_for :user
  devise_scope :user do
    get '/login', :to => "devise/sessions#new"
    delete '/logout', :to => "devise/sessions#destroy"
  end

  get '/error' => "pages#error"
  get '/contact' => "pages#contact"
end
