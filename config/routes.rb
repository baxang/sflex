require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/jobs'

  root 'home#welcome'

  resources :series, only: [:index, :show, :favourite] do
    member do
      put :favourite
    end
  end
  resources :episodes, only: [:index, :show, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
