# frozen_string_literal: true

class Admin::DashboardController < ApplicationController
  layout "admin_dashboard"

  def dashboard
    authorize([:admin, :dashboard], :dashboard?)
  end
end
