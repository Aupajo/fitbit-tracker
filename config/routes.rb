Rails.application.routes.draw do
  root to: "fitbit_users#index"

  resources :fitbit_users, only: [:index, :show]

  resources :fitbit_oauth_connections, only: [:new] do
    get '/', action: :confirm, on: :collection
  end

  resources :authenticated_users, only: [:create]
end
