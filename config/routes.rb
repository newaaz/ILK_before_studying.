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

  resources :towns do
    get :hotels, on: :member
    get :cafebars, on: :member
    get :points, on: :member
    get :services, on: :member
    get :actives, on: :member
  end

  resources :hotel_categories, except: :show
  resources :hotels
  resources :rooms
  resources :orders, except: [:edit, :update, :destroy]

  resources :carts, only: [:show, :destroy]
  resources :line_items, only: :create

  resources :cafebars
  resources :tagcafebars, except: :show

  resources :points  
  resources :point_categories, except: :show

  resources :services
  resources :service_categories, except: :show

  resources :actives
  resources :active_categories, except: :show

end
