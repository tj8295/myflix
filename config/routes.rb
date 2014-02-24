Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'

  resources :categories, only: [:show]
  resources :users
  resources :queue_items, only: [:create, :destroy]

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]

    collection do
      get :search, to: 'videos#search'
    end
  end
end
