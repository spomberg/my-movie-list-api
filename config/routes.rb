Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :list, :user, :session

  get 'api/lists/' => 'list#index'
  get 'api/lists/:id' => 'list#show'
  get 'api/lists/:id/edit-view' => 'list#edit_view'
  get 'api/logout' => 'session#logout'
  
  get 'api/user/' => 'user#authenticate'
  get 'api/user/lists' => 'user#view_lists'
  
  post 'api/list/new' => 'list#new'
  post 'api/login' => 'session#login'
  post 'api/signup' => 'session#signup'
  
  put 'api/list/:id/edit' => 'list#edit'
  put 'api/list/search-movie' => 'list#search'
  
  delete 'api/list/:id/delete' => 'list#destroy'
  
end
