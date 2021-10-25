Rails.application.routes.draw do
  root 'dashboards#show'

  resource :sessions, only: %i[new create destroy]

  resources :users, only: %i[new create show edit update destroy]
  resources :ideas, only: %i[new create destroy]
  resources :groups, only: %i[new create show edit update destroy]
  resources :invites, only: %i[show update]
end
