# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: :create
    resources :brands, only: :create do
      member do
        patch :activate
        patch :inactivate
      end
      resources :products, controller: 'brands/products' do
        member do
          patch :activate
          patch :inactivate
        end
      end
    end
    resources :clients, only: :create do
      resources :products, only: :create, controller: 'clients/products'
      resources :cards, only: :create, controller: 'clients/cards' do
        patch :cancel, on: :member
      end
    end
  end
end
