Rails.application.routes.draw do
  resources :users
  resources :sessions
  root to: 'site#index'
end
