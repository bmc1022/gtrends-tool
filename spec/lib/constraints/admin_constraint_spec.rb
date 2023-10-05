# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminConstraint, type: :constraint) do
  describe ".matches?" do
    let(:request)      { instance_double(ActionDispatch::Request, session: session_hash) }
    let(:session_hash) { { "warden.user.user.key" => [[user.id]] }                       }

    context "when the warden user key in the session matches an admin account" do
      let(:user) { create(:user, :admin) }

      it "returns true" do
        expect(described_class.matches?(request)).to be(true)
      end
    end

    context "when the warden user key in the session matches a non-admin account" do
      let(:user) { create(:user) }

      it "returns false" do
        expect(described_class.matches?(request)).to be(false)
      end
    end

    context "when there is no warden user key in the session" do
      let(:session_hash) { {} }

      it "returns false" do
        expect(described_class.matches?(request)).to be(false)
      end
    end
  end
end
