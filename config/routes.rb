Rails.application.routes.draw do
  root 'dashboards#show'

  resource :sessions, only: %i[new create destroy]
  resources :users, except: :index
  resources :groups, except: :index
end
