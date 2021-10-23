Rails.application.routes.draw do
  root 'dashboards#show'

  resource :sessions
  resources :users
  resources :ideas
  resources :groups do
    post 'join', to: 'groups#join'
    post 'shuffle', to: 'groups#shuffle'
  end
end
