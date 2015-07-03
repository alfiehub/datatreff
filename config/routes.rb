Rails.application.routes.draw do
  resources :results
  resources :pages
  resources :competitions do
    resources :results
    member do
      get :start
      get :started
      get :matches
      get :result
    end
  end
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
