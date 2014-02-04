Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get '/home', to: 'videos#index'
  get '/register', to: 'sessions#new'
  post '/register', to: 'sessions#create'


  resources :users


  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
  end

  resources :categories
end
