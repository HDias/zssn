Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: [] do
        resources :infection_reports, only: [:create], module: :survivors
        resource :inventory, only: [] do
          member do
            patch ':item_id', to: 'survivors/inventories#update'
            delete ':item_id', to: 'survivors/inventories#destroy'
          end
        end
      end
      resources :trades, only: [:create]
    end
  end
end
