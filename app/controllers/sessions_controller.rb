# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  layout "auth", only: [:new]
end
