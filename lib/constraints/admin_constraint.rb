# frozen_string_literal: true

class AdminConstraint
  def self.matches?(request)
    user = request.env["warden"].user
    user&.has_role?(:admin) || false
  end
end
