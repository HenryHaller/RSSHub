Rails.application.routes.draw do
  root to: 'pages#home'
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  post 'auth/activate', to: 'authentication#activate'
  post 'auth/password_recovery_request', to: 'authentication#password_recovery_request'
  post 'auth/password_recovery_attempt', to: 'authentication#password_recovery_attempt'
  post 'auth/update_password', to: 'authentication#update_password'

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :shows, only: %i[index show new create destroy]
    resources :episodes, only: [:index]
  end
  scope :admin do
    get 'panel', to: 'admin#panel'
  end
  get 'subscriptions', to: 'shows#subscriptions'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
