# frozen_string_literal: true

class AdminConstraint
  def self.matches?(request)
    return false unless request.session["warden.user.user.key"]

    user_id = request.session["warden.user.user.key"][0][0]
    user = User.find_by(id: user_id)
    user&.has_role?(:admin)
  end
end
