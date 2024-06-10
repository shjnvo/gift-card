# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: :create
  end
end
