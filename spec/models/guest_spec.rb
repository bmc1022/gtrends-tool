# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Guest, type: :model) do
  subject(:guest) { build(:guest) }

  describe "attributes and indexes" do
    # Attributes
    describe ":guest_id" do
      it { is_expected.to respond_to(:guest_id) }
      it { expect(guest.guest_id).to be_a(String) }
    end
  end

  describe "#has_role?" do
    context "when role is :guest" do
      it "returns true" do
        expect(guest.has_role?(:guest)).to be(true)
      end
    end

    context "when role is not :guest" do
      it "returns false" do
        expect(guest.has_role?(:registered)).to be(false)
      end
    end
  end
end
