Rails.application.routes.draw do
  root "sessions#new"

  resource :dashboard, only: %i[show]

  get "/join", to: "join#new"
  get "/join/:join_code", to: "join#new", as: :join_with_code
  post "/join", to: "join#create"

  resource :session, only: %i[new create destroy] do
    resource :magic_link, only: %i[show create]
  end

  resource :display_name, only: %i[new create]

  resource :email_confirmation, only: %i[show create destroy] do
    post :resend
  end

  resources :users, only: %i[show edit update destroy]

  resources :ideas, only: %i[create destroy]

  resources :groups, only: %i[new create edit update destroy] do
    get :created, on: :member

    resources :memberships, only: :destroy, param: :user_id, controller: :group_memberships
    resources :rules, only: %i[create destroy], controller: :group_rules
    resource :reset, only: :create, controller: :group_resets
  end

  get "up" => "rails/health#show", :as => :rails_health_check
end
