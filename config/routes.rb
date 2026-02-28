Rails.application.routes.draw do
  root "homepage#home"

  get "signup", to: "volunteers#new"
  post "signup", to: "volunteers#create"

  get "login", to: "logins#show"
  post "login", to: "logins#create"
  delete "logout", to: "logins#destroy"

  # Volunteer routes
  get "volunteer/home", to: "volunteers#home", as: :volunteer_home
  get "volunteer/assigned_events", to: "volunteers#assigned_events", as: :assigned_events
  get "volunteer/history", to: "volunteers#history", as: :volunteer_history
  resource :volunteer_profile, controller: "volunteers", only: %i[show edit update destroy]
  resources :events, only: %i[index show]
  resources :volunteer_assignments, only: %i[index destroy]
  post "events/:event_id/volunteer_assignments", to: "volunteer_assignments#create", as: :event_volunteer_assignments

  # Admin routes
  get "admin/home", to: "admins#home", as: :admin_home
  get "admin/analytics", to: "admin_analytics#index", as: :admin_analytics
  resource :admin_profile, controller: "admins", only: %i[show edit update]
  resources :admin_volunteers, controller: "admin_volunteers"
  resources :admin_events, controller: "admin_events"
  resources :admin_volunteer_assignments, controller: "admin_volunteer_assignments", only: %i[index new create edit update destroy]
  patch "admin_volunteer_assignments/:id/approve", to: "admin_volunteer_assignments#approve", as: :approve_admin_volunteer_assignment
  patch "admin_volunteer_assignments/:id/complete", to: "admin_volunteer_assignments#complete", as: :complete_admin_volunteer_assignment

  get "up" => "rails/health#show", as: :rails_health_check
end
