Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
  resources :games, only: [:new, :create, :index]
  get '/games/menu', to: 'games#menu'
  get '/games/:id/play', to: 'games#play'
  get '/move/:direction', to: 'games#move_player', as: 'move'
  get '/games/:id/quit', to: 'games#safe_exit', as: 'quit_game'
  get '/games/:id/delete', to: 'games#destroy', as: 'delete_game'
  get '/nextturn', to: 'games#next_turn', as: 'next_turn'
  get '/games/continue', to: 'games#continue', as: 'continue'

end
