Rails.application.routes.draw do
  root "home#show"

  resource :dashboard, only: %i[show]

  get "/join", to: "join#new"
  get "/join/:join_code", to: "join#new", as: :join_with_code
  post "/join", to: "join#create"

  resource :session, only: %i[new create destroy]

  resources :users, only: %i[new create show edit update destroy]

  resources :ideas, only: %i[create destroy]

  resources :groups, only: %i[new create edit update destroy] do
    resources :memberships, only: :destroy, param: :user_id, controller: :group_memberships
  end

  get "up" => "rails/health#show", :as => :rails_health_check
end
