Rails.application.routes.draw do

  root 'home#welcome'

  resources :series, only: [:index, :show]
  resources :episodes, only: [:index, :show, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
