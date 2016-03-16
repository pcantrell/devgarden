Rails.application.routes.draw do

  root 'home#show'

  %w(login about contact).each do |page|
    get "/#{page}" => "high_voltage/pages#show", id: page
  end

  get "/logout" => "sessions#destroy", as: :logout
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/failure" => "sessions#create_failed"

  resources :projects
  resources :people
  resources :roles
  resources :events
  resources :tags
  resources :job_reports

end
