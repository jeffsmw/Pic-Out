Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get '/' => 'home#index', as: :home
  # get '/search' => 'home#show', as: :search
  post({'/' => 'home#create', as: :search})

  resources :users
  resources :friendships, only: [:create, :destroy]
  resources :sessions, only: [:destroy, :create, :new] do
    delete :destroy, on: :collection
  end
  resources :restaurants, only: [:show, :create, :index]
end
