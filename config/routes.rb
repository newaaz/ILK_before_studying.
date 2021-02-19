Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'main#home'

  # static pages
  get '/contacts', to: 'main#contacts'
  get '/about', to: 'main#about'
  get '/admin', to: 'main#admin'
  get '/privacy', to: 'main#privacy'

  # users
  resources :users  
  get '/signup', to: 'users#new'

  # login & logout
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy' 
  
  # for account activation
  resources :account_activations, only: [:edit]
  # for password reset
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :hotel_categories, except: :show

  resources :towns

  resources :hotels

end
