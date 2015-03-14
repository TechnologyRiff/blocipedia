Rails.application.routes.draw do

  resources :wikis do
    member do 
      put "auth"
    end
  end

  resources :favorites, only: [:create, :destroy]
  
  resources :charges, only: [:new, :create]

  devise_for :users
  resources :users, only: [:index, :show] do 
    post 'downgrade'
    put 'role'
    patch 'role'
  end
  
  resources :collaborations, only: [:new, :create, :destroy]

  get 'welcome/about'

  get 'welcome/contact'

    root to: 'welcome#index'

end
