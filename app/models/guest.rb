# frozen_string_literal: true

class Guest
  attr_reader :guest_id

  def initialize(guest_id)
    @guest_id = guest_id.to_s
  end
end
