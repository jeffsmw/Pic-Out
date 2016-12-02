Rails.application.routes.draw do
  get '/' => 'home#index', as: :home

  resources :users
  resources :sessions, only: [:destroy, :create, :new] do
    delete :destroy, on: :collection
  end
end
