Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  get "/finch/callback", to: "finch_callbacks#handle"
  get "finch_callbacks/disconnect", to: "finch_callbacks#disconnect", as: :disconnect_finch

  # Define routes for customers with only the "connect" action as a member route
  resources :customers, only: [:index] do
    get :connect, on: :member
  end

  resources :archive_payrolls, only: %i[index new create show]
  resources :payrolls, only: %i[index]
  get "download/:payroll_payment_id", to: "archive_payrolls#download", as: :download
  post "send_email/:payroll_payment_id", to: "archive_payrolls#send_email", as: :send_email

  resources :payrolls
  root "home#index"  # Set home page as default after login
end
