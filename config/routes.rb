Rails.application.routes.draw do
  resources :images
  localized do
    resources :file_competitions do
      resources :file_results
    end
    resources :results
    resources :pages
    resources :competitions do
      resources :results
      resources :team_seeds
      member do
        get :all
        get :start
        get :started
        get :matches
      end
    end
    resources :teams
    resources :users
    resources :sessions
    resources :competition_teams, only: :destroy
    resources :user_teams
  end

  get 'logg_ut', to: 'sessions#destroy', as: 'logg_ut'
  get 'registrering', to: 'users#new', as: 'registrering'
  get 'logg_inn', to: 'sessions#new', as: 'logg_inn'
  get 'rediger_bruker', to: 'users#edit', as: 'rediger_bruker'

  get ':id' => 'pages#show'


  root to: 'site#index'
end
