Rails.application.routes.draw do

  devise_for :users
  resources :users, only: [:show]

  resources :wikis

  resources :subscriptions, only: [:new, :create]
  get '/downgrade', to: 'subscriptions#downgrade'

  root to: 'welcome#index'
  
end
