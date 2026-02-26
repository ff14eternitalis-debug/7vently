Rails.application.routes.draw do
  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :users, only: [ :show, :edit, :update ]
  resources :events, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
    resources :attendances, only: [ :new, :create, :index ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    root "application#index"
    resources :users
    resources :event_submissions, only: [ :index, :show, :edit, :update ]
    resources :events
  end

  root "events#index"
end
