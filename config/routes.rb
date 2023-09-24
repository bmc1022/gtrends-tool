# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  root to: "gtrends#index"

  # Skip creation of the default :passwords, :registrations and :sessions Devise routes to avoid
  # path duplication with the custom paths in the devise_scope block below.
  # Use the specified custom user controllers instead of the default Devise controllers.
  devise_for :users, skip: [:passwords, :registrations, :sessions], controllers: {
    passwords: "users/passwords", registrations: "users/registrations", sessions: "users/sessions"
  }

  devise_scope :user do
    # Authentication
    get    "login",          to: "users/sessions#new",          as: :new_user_session
    post   "login",          to: "users/sessions#create",       as: :user_session
    delete "logout",         to: "users/sessions#destroy",      as: :destroy_user_session

    # Password reset
    get    "reset-password", to: "users/passwords#new",         as: :new_user_password
    post   "reset-password", to: "users/passwords#create",      as: :user_password
    get    "edit-password",  to: "users/passwords#edit",        as: :edit_user_password
    patch  "edit-password",  to: "users/passwords#update",      as: :update_user_password
    put    "edit-password",  to: "users/passwords#update"

    # User registration
    get    "sign-up",        to: "users/registrations#new",     as: :new_user_registration
    post   "sign-up",        to: "users/registrations#create",  as: :user_registration
    get    "close-account",  to: "users/registrations#cancel",  as: :cancel_user_registration
    delete "close-account",  to: "users/registrations#destroy", as: :destroy_user_registration
    get    "edit-profile",   to: "users/registrations#edit",    as: :edit_user_registration
    patch  "edit-profile",   to: "users/registrations#update",  as: :update_user_registration
    put    "edit-profile",   to: "users/registrations#update"
  end

  authenticate :user, ->(user) { user.has_role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :gtrends, only: [:index, :create, :destroy], path: "/"
end
