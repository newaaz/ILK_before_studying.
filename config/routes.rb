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

  # change resource activation
  get '/change_activated', to: 'application#change_activated'
  # change resource rating
  post '/change_rating', to: 'application#change_rating'
 
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
  resources :hotels do
    post :send_message, on: :member
  end
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

  resources :actives do    
    post :change_promo, on: :member
  end
  resources :active_categories, except: :show

end
