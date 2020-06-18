Rails.application.routes.draw do
  root to:'home#index'
  get 'home/about'
  post 'home/logout'
  # get 'users/show'
  # get 'books/index'
  # get 'books/show'
  # get 'books/new'
  # get 'books/edit'
  devise_for :users
  resources :books do
    resources :book_comments, only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    #↑ resource の場合、コントローラにidが含まれない
  end
  resources :users, only:[:show, :edit, :update, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
