Rails.application.routes.draw do
  resources :pages
  resources :competitions
  resources :teams
  resources :users
  resources :sessions
  resources :competition_teams
  resources :user_teams

  get 'logg_ut', to: 'sessions#destroy', as: 'logg_ut'
  get 'registrering', to: 'users#new', as: 'registrering'
  get 'logg_inn', to: 'sessions#new', as: 'logg_inn'

  get ':id' => 'pages#show'


  root to: 'site#index'
end
