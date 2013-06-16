Highlander::Application.routes.draw do

  # Redirect leaderboard.hooroo.com -> hooroo.hilander.io
  #
  match '(*foo)' => redirect { |p|
    "http://hooroo.hilander.io/#{p[:foo]}"
  },
  constraints: { host: 'leaderboard.hooroo.com' }, via: [ :get ]

  # Redirect thequickening.herokuapp.com -> www.hilander.io
  #
  match '(*foo)' => redirect { |p|
    "http://hilander.io"
  },
  constraints: { host: 'thequickening.herokuapp.com' }, via: [ :get ]

  namespace :api do

    Metric::NAMES.each do |metric|
      post metric => 'events#create', :defaults => { metric: metric }
    end

    resources :events, only: [ :create ]

    namespace :adapters do
      resources :github,  only: [ :create ]
      resources :twitter, only: [ :create ]
    end
  end

  get   '/signout' => 'sessions#destroy', as: :signout
  post  '/auth/google_apps/callback' => 'sessions#create'

  constraints(:subdomain => /^(?!www).+$/) do

    resources :users
    resources :badges, only: [ :index, :show ]
    resources :bounties

    get '/about' => 'high_voltage/pages#show', id: 'about'

    root to: 'welcome#index'
  end

  constraints(:subdomain => /.*/) do

    resources :registrations, only: [ :index, :create ]

    root to: 'registrations#index', as: 'root_register'
  end
end
