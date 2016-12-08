Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get '/' => 'home#index', as: :home
  get '/search' => 'home#show', as: :search

  resources :users
  resources :sessions, only: [:destroy, :create, :new] do
    delete :destroy, on: :collection
  end

end
