Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/signup', to: 'users#new'
  get    '/about',  to: 'static_pages#about'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
end
