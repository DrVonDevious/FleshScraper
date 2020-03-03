Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
<<<<<<< HEAD
  get '/random', to: 'games#random', as: 'random'
=======
  get '/testfield', to: 'games#random', as: 'random'
>>>>>>> 327c2687fb6c9d4f06ba8d6188cdca207bfce487


  # Session routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authorized', to: 'sessions#page_requires_login'

  # User Routes
  resources :users, only: [:new, :create, :index]

  # Static routes
  root 'static#home'
  get 'static/about'

  # Game routes
  get '/users/:id/games', to: 'games#index'


end
