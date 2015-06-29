Rails.application.routes.draw do
  resources :teams
  resources :users
  resources :sessions

  get 'logg_ut', to: 'sessions#destroy', as: 'logg_ut'
  get 'regsitrering', to: 'users#new', as: 'registrering'
  get 'logg_inn', to: 'sessions#new', as: 'logg_inn'


  root to: 'site#index'
end
