Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #this is only for testing purposes
  get '/testfield', to: 'games#random', as: 'random'
  get '/nextturn', to: 'games#next_turn', as: 'next_turn'
  get '/showfield', to: 'games#show_field', as: 'show_field'


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
  get '/games/menu', to: 'games#menu'
  get '/games', to: 'games#index'
  get '/games/new', to: 'games#new'
  post '/games', to: 'games#create'


end
