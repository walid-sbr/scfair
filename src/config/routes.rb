Rails.application.routes.draw do
  resources :datasets do
    collection do
      post :search
    end
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'home#index'

  get 'tools', to: 'home#tools', as: :tools
  get 'contact-us', to: 'home#contact', as: :contact
  get 'resources', to: 'home#resources', as: :resources
  get 'metadata-schema', to: 'home#metadata_schema', as: :metadata_schema
  get 'about', to: 'home#about', as: :about
  get 'community', to: 'home#community', as: :community
  get 'explore', to: 'datasets#index', as: :explore

end
