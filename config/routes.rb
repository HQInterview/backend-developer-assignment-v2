Rails.application.routes.draw do
  root "rooms#index"

  resources :users, only: [:new, :create] do
    get :activate, on: :member
    get :edit_password, on: :member
    post :update_password, on: :member
    put :update_password, on: :member
  end

  resource :users, only: [] do
    get :new_session
    post :create_session
    get :destroy_session
    get :new_act_email
    post :send_act_email
    get :new_reset_password
    post :create_reset_password
  end

  get "register" => "users#new",             as: :register
  get "login"    => "users#new_session",     as: :login
  get "logout"   => "users#destroy_session", as: :logout

  resources :rooms, only: [:index, :show]
  resource :rooms, only: [] do
    post :publish
  end
end
