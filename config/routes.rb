Rails.application.routes.draw do
  # Authentication
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # Dashboard
  get "dashboard", to: "dashboard#show"

  # Flight Schools with nested Aircraft, Downtime Events, and Maintenance Logs
  resources :flight_schools do
    resources :aircrafts do
      member do
        post :mark_down
        post :mark_available
      end
      resources :downtime_events, except: [:index, :show]
      resources :maintenance_logs, except: [:index, :show]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "dashboard#show"
end
