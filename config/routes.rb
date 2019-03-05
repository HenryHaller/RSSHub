Rails.application.routes.draw do
  root to: 'pages#home'
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  get 'auth/activate', to: 'authentication#activate'

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
