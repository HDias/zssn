Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: [:create]
      resources :infection_reports, only: [:create]
    end
  end
end
