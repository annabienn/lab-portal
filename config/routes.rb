Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root "home#index"

  resources :posts, only: [:index, :show, :new, :create]
  resources :contacts, only: [:index, :create, :destroy]
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  resources :notifications, only: [:index, :update]
end
