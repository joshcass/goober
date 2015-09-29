Rails.application.routes.draw do
  root 'home#index'
  resources :drivers, only: [:new, :create, :show]
  resources :riders, only: [:new, :create, :show]
  resources :sessions, only: [:create]
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout
end
