# frozen_string_literal: true

class AdminConstraint
  def self.matches?(request)
    warden_key = request.session["warden.user.user.key"]
    return false unless warden_key

    user_id = warden_key[0][0]
    User.find(user_id)&.has_role?(:admin)
  end
end
