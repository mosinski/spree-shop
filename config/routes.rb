Rails.application.routes.draw do
  get '/cart' => 'store#cart'
  get '/checkout' => 'store#checkout'
  root to: "pages#home"
  mount Spree::Core::Engine, :at => '/'

  devise_for :user
  devise_scope :user do
    get '/login', :to => "devise/sessions#new"
    delete '/logout', :to => "devise/sessions#destroy"
  end

  get '/error' => "pages#error"
end
