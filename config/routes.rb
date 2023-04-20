Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'
  get '/public_recipes', to: 'recipes#index'
  resources :users
  resources :recipes
  resources :foods
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
