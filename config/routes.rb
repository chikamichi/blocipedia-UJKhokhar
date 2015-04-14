Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:show]

  resources :wikis

  resources :subscriptions, only: [:new, :create]
  delete '/downgrade', to: 'subscriptions#downgrade'

  root to: 'welcome#index'

end
