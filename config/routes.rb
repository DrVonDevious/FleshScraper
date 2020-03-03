Rails.application.routes.draw do

  # Session routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authorized', to: 'sessions#page_requires_login'

  # User Routes
  resources :users, only: [:new, :create]

  # Static routes
  root 'static#home'
  get 'static/about'

end
