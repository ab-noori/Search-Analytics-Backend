Rails.application.routes.draw do
  namespace :api do
    resources :articles, only: [:create, :index]
    resources :searches, only: [:index, :show, :create]
  end
end
