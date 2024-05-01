# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdminConstraint, type: :constraint) do
  describe ".matches?" do
    let(:request) { instance_double(ActionDispatch::Request, env: { "warden" => warden }) }
    let(:warden)  { instance_double(Warden::Proxy, user:)                                 }

    context "when the user is an administrator" do
      let(:user) { create(:user, :admin) }

      it "returns true" do
        expect(described_class.matches?(request)).to be(true)
      end
    end

    context "when the user is not an administrator" do
      let(:user) { create(:user) }

      it "returns false" do
        expect(described_class.matches?(request)).to be(false)
      end
    end

    context "when there is no user logged in" do
      let(:user) { nil }

      it "returns false" do
        expect(described_class.matches?(request)).to be(false)
      end
    end
  end
end
