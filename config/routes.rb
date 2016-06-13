Rails.application.routes.draw do
  root 'home#welcome'

  resources :series, only: [:index, :show, :favourite] do
    member do
      put :favourite
    end
  end
  resources :episodes, only: [:index, :show, :destroy, :crawl] do
    member do
      put :crawl
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
