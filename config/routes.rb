Rails.application.routes.draw do
  resources :file_results
  resources :file_competitions do
    resources :file_results
  end
  resources :results
  resources :pages
  resources :competitions do
    resources :results
    member do
      get :start
      get :started
      get :matches
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
  get 'chat', to: 'site#irc', as: 'chat'

  get ':id' => 'pages#show'


  root to: 'site#index'
end
