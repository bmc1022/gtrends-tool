# frozen_string_literal: true

require Rails.root.join("lib/constraints/admin_constraint")
require "sidekiq/web"

Rails.application.routes.draw do
  root to: "gtrends#index"

  # The Sidekiq web UI is only accessible by administrators. If the constraint is not met, the next
  # matching route will redirect non-admin users and guests to the login page.
  mount Sidekiq::Web, at: "/sidekiq", constraints: AdminConstraint
  get "sidekiq", to: redirect("login")

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

  resources :gtrends, only: [:index, :create, :destroy], path: "/"
end
