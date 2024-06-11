# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    get 'brands/create'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: :create
    resources :brands, only: :create do
      member do
        patch :activate
        patch :inactivate
      end
    end
  end
end
