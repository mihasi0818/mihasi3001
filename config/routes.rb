Rails.application.routes.draw do
  get 'notifications/index'
  get 'notifications/show'
  get 'notifications/new'
  get 'notifications/create'
  get 'notifications/edit'
  get 'notifications/update'
  get 'notifications/destroy'
  post 'posts' => 'posts#create'
  root "posts#index"
  get "guest_login", to: "guest_sessions#create"
  post "guest_login", to: "guest_sessions#create"
   

  
  
    resources :notifications
 
  


  get 'password_resets/new'
  get 'password_resets/edit'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get"logout", to: "sessions#destroy"
  
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :users, except: [:new] do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :relationships

  resources :posts do
    collection do
      get :oldest_first
      get :most_liked
    end
  end
  
  
  # ... other routes ...
end

