Rails.application.routes.draw do
  get '/cart', to: 'store#cart', as: 'cart_store'
  get '/checkout', to: 'store#checkout', as: 'checkout_store'
  root to: "pages#home"
  mount Spree::Core::Engine, :at => '/'

  devise_for :user
  devise_scope :user do
    get '/login', :to => "devise/sessions#new"
    delete '/logout', :to => "devise/sessions#destroy"
  end

  get '/error' => "pages#error"
end
