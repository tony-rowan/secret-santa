Rails.application.routes.draw do
  root "home#show"

  resource :dashboard, only: %i[show]
  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create show edit update destroy]
  resources :ideas, only: %i[create destroy]
  resources :groups, only: %i[new create show edit update destroy]
  resources :invites, only: %i[show update]

  get "up" => "rails/health#show", :as => :rails_health_check
end
