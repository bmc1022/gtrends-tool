# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions], controllers: { sessions: "sessions" }
  devise_scope :user do
    get  "login", to: "sessions#new", as: :new_user_session
    post "login", to: "sessions#create", as: :user_session
    delete "logout", to: "sessions#destroy"
  end

  authenticate :user do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :gtrends, only: [:index, :create, :destroy], path: "/"
end
