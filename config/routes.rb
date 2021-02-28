Rails.application.routes.draw do

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
 
  resources :account_activations, only: [:edit]  
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :hotel_categories, except: :show
  resources :towns
  resources :hotels
  resources :rooms
  resources :orders, except: [:edit, :update, :destroy]

end
