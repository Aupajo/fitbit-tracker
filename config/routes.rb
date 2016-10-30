Rails.application.routes.draw do
  resources :fitbit_oauth_connections, only: [:new] do
    get '/', action: :confirm, on: :collection
  end
end
