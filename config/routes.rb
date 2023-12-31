Rails.application.routes.draw do
  defaults format: :json do
  resources :custom_fields
  resources :categories
  resources :tags
  resources :likes
  resources :comments
  resources :collections
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check
  end
end
