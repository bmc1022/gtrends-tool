# frozen_string_literal: true

class Admin::DashboardPolicy < ApplicationPolicy
  def dashboard?
    @user&.has_role?(:admin)
  end
end
