Rails.application.routes.draw do
  root 'root#show'

  resource :dashboard, only: %i[show]
  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create show edit update destroy]
  resources :ideas, only: %i[new create destroy]
  resources :groups, only: %i[new create show edit update destroy]
end
