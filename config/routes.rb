Rails.application.routes.draw do
  defaults format: :json do
  devise_for :users, path: '', path_names: {
    sign_in: 'signin',
    sign_out: 'signout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get '/current_user', to: 'current_user#index'
  resources :users,  only: [:index, :show, :update, :destroy]
  resources :items
  resources :categories
  resources :tags
  resources :likes
  resources :comments
  resources :collections
  get "up" => "rails/health#show", as: :rails_health_check
  end
end
