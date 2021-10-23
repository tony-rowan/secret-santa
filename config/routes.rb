Rails.application.routes.draw do
  resources :users, except: :index
  resources :groups, except: :index
end
