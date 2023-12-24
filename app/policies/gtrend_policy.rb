# frozen_string_literal: true

class GtrendPolicy < ApplicationPolicy
  def index?
    @user.present?
  end

  def create?
    @user.present?
  end

  def destroy?
    case @user
    when User  then @user.has_role?(:admin) || @record.user == @user
    when Guest then @record.guest_id == @user.guest_id
    else false
    end
  end

  class Scope < Scope
    def resolve
      case @user
      when User  then @user.has_role?(:admin) ? @scope.all : @scope.where(user: @user)
      when Guest then @scope.where(guest_id: @user.guest_id).or(Gtrend.seeded_trends)
      else @scope.none
      end
    end
  end
end
