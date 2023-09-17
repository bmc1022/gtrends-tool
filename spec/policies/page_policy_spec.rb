# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PagePolicy, type: :policy) do
  subject { described_class.new(user, :page) }

  context "when user is an admin" do
    let(:user) { create(:user, :admin) }

    it { is_expected.to permit_action(:home) }
  end

  context "when user is a registered user" do
    let(:user) { create(:user) }

    it { is_expected.to permit_action(:home) }
  end

  context "when user is a guest" do
    let(:user) { nil }

    it { is_expected.to permit_action(:home) }
  end
end
