Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: [:create, :update]
      resources :infection_reports, only: [:create]
    end
  end
end
