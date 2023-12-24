# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    guest_id { SecureRandom.uuid }

    initialize_with { new(guest_id) }
  end
end
