Rails.application.routes.draw do
  get 'notifications/index'
  post 'posts' => 'posts#create'
  root "posts#index"
  get "guest_login", to: "guest_sessions#create"
  post "guest_login", to: "guest_sessions#create"
  get 'password_resets/new'
  get 'password_resets/edit'
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get"logout", to: "sessions#destroy"
  get 'account_activations/:id/edit', to: 'account_activations#edit', as: 'edit_account_activation'
  
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :users, except: [:new] do
    member do
      post 'follow'
      delete 'unfollow'
    end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
  end

  resources :relationships
  resources :notifications
  resources :posts do
    collection do
      get :oldest_first
      get :most_liked
    end
  end

resources :account_activations, only: [:edit]
resources :password_resets, only: [:new, :create, :edit, :update]

end
