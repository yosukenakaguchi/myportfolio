Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root   'static_pages#home'
  get    '/signup', to: 'users#new'
  get    '/about',  to: 'static_pages#about'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :recipes,             only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]
end
