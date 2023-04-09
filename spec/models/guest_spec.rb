# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Guest, type: :model) do
  subject(:guest) { described_class.new(SecureRandom.uuid) }

  describe "attributes and indexes" do
    # Attributes
    describe ":guest_id" do
      it { is_expected.to respond_to(:guest_id) }
      it { expect(guest.guest_id).to be_a(String) }
    end
  end
end
