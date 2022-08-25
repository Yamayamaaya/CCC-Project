Rails.application.routes.draw do
  get 'claims/list' => 'claims#list' 
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'statics#top'
  resources :claims do
    resources :likes, only: [:create, :destroy]
    resources :questions, only: [:create]
  end
  resources :users, only: [:show]
  resources :parent_children, only: [:create, :destroy]
  
end
