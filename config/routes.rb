Rails.application.routes.draw do
  defaults format: :json do

  resources :users,  only: [ :show, :update, :destroy]
  resources :items
  resources :categories
  resources :tags
  resources :likes
  resources :comments
  resources :collections
  get 'collection/custom_fields/:id', to: 'collections#get_collection_custom_fields'
  get 'collection_items/:collection_id', to: 'items#collection_items'

  devise_for :users, path: '', path_names: {
    sign_in: 'signin',
    sign_out: 'signout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

# routes for only admin user
  get '/current_user', to: 'current_user#index'
  get 'admin/users', to: 'admin_dashboard#index'
  patch 'admin/users/block', to: 'admin_dashboard#block_multiple'
  patch 'admin/users/unblock', to: 'admin_dashboard#unblock_multiple'
  patch 'admin/users/role_toggle', to: 'admin_dashboard#toggle_role'
  delete 'admin/users/delete', to: 'admin_dashboard#destroy_multiple'
  get "up" => "rails/health#show", as: :rails_health_check
  end
end
