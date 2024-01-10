# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :searches, only: %i[index show create]
  end
end
