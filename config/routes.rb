Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :shows, only: %i[index show new create destroy]
  resources :episodes, only: [:index]
  scope :admin do
    get 'panel', to: 'admin#panel'
  end
  get 'urls', to: 'shows#urls'
  get 'csv', to: 'shows#csv'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
