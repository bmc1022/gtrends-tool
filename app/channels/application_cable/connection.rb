# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
      reject_unauthorized_connection unless current_user
    end

    private

    def find_current_user
      env["warden"].user || Guest.new(cookies[:guest_identifier])
    end
  end
end
