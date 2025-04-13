Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :locations, only: [:create] do
        collection do
          get ':category', to: 'locations#by_category'
          post 'search', to: 'locations#search'
        end
        member do
          post 'trip-cost', to: 'locations#trip_cost'
        end
      end
    end
  end
end
