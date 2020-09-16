Rails.application.routes.draw do
  root to:'home#index'
  get 'home/about'
  post 'home/logout'

  devise_for :users
  resources :books do
    #comment
    resources :book_comments, only:[:create, :destroy]
    # favorite (resource の場合、コントローラにidが含まれない)
    resource :favorites, only:[:create, :destroy]
  end

  resources :users, only:[:show, :edit, :update, :index] do
    # search
    collection do
      get 'search/search'
    end

    # follow
    member do
      get :following, :followers
    end
  end
  resources :relationships, only:[:create, :destroy]

  resources :messages, only: [:create, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
