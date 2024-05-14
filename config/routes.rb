# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  root to: "gtrends#index"

  # Authorization logic for the Sidekiq Web UI found in "lib/middleware/sidekiq_auth.rb".
  mount Sidekiq::Web, at: "/sidekiq"

  # Skip creation of the default :sessions Devise routes to avoid path duplication with the
  # custom paths in the devise_scope block below.
  # Use the specified custom user controllers instead of the default Devise controllers.
  devise_for :users, skip: [:sessions], controllers: { sessions: "users/sessions" }

  devise_scope :user do
    # Authentication
    get    "login",  to: "users/sessions#new",     as: :new_user_session
    post   "login",  to: "users/sessions#create",  as: :user_session
    delete "logout", to: "users/sessions#destroy", as: :destroy_user_session
  end

  resources :gtrends, only: [:create, :destroy], path: "/"
end
