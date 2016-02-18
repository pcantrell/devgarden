Rails.application.routes.draw do

  root 'home#show'

  get "/login" => "high_voltage/pages#show", id: 'login'
  get "/logout" => "sessions#destroy", as: :logout
  get "/auth/:provider/callback" => "sessions#create"

  resources :projects
  resources :people
  resources :roles
  resources :events
  resources :tags

end
