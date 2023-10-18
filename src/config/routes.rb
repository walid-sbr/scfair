Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :home do
    collection do
      get :index
      get :team
    end
  end


  root to: 'home#index'

  

end
