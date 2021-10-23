Rails.application.routes.draw do
  resources :groups, except: :index
end
