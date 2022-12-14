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

  resources :carts, only: [:show, :destroy]
  resources :line_items, only: :create  

  resources :images, only: [:create]

  # hotels
  resources :hotel_categories, except: :show
  resources :hotels do
    post :send_message, on: :member
    resources :images, only: [:destroy]
  end
  resources :rooms, except: [:show, :index] do
    resources :images, only: [:destroy]
  end
  resources :orders, except: [:edit, :update, :destroy]
  
  # cafebars
  resources :cafebars do
    resources :images, only: [:destroy]
  end
  resources :tagcafebars, except: :show

  # points
  resources :points do
    resources :images, only: [:destroy]
  end 
  resources :point_categories, except: :show

  # services
  resources :services do
    resources :images, only: [:destroy]
  end
  resources :service_categories, except: :show

  # actives
  resources :active_categories, except: :show
  resources :actives do    
    post :change_promo, on: :member
    resources :images, only: [:destroy]
  end
  resources :order_actives, except: [:edit, :update, :destroy]

end
