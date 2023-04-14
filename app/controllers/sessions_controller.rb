# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_after_action :verify_authorized, only: [:create, :new, :destroy]

  layout "auth", only: [:new]
end
