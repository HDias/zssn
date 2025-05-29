Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :infection_reports, only: [:create]
      resources :survivors, only: [] do
        resource :inventory, only: [] do
          member do
            patch ':item_id', to: 'survivors/inventories#update'
            delete ':item_id', to: 'survivors/inventories#destroy'
          end
        end
      end
      resources :survivors, only: [:create, :update]
      resources :trades, only: [:create]

      namespace :reports do
        get 'infected_percentage', to: 'infected_percentage#index'
        get 'non_infected_percentage', to: 'non_infected_percentage#index'
        get 'average_items_per_survivor', to: 'average_items_per_survivor#index'
        get 'points_lost_by_infected', to: 'points_lost_by_infected#index'
      end
    end
  end
end
