Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'tools', to: 'home#tools', as: :tools
  get 'contact-us', to: 'home#contact', as: :contact
  get 'resources', to: 'home#resources', as: :resources

  resources :home do
    collection do
      get :index
      get :team
    end
  end


  root to: 'home#index'



end
