# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Admin::DashboardPolicy, type: :policy) do
  subject { described_class.new(user, :dashboard) }

  context "when user is an administrator" do
    let(:user) { create(:user, :admin) }

    it { is_expected.to permit_actions(:dashboard) }
  end

  context "when user is a registered user" do
    let(:user) { create(:user) }

    it { is_expected.to forbid_actions(:dashboard) }
  end

  context "when user is a guest" do
    let(:user) { build(:guest) }

    it { is_expected.to forbid_actions(:dashboard) }
  end

  context "when user does not exist" do
    let(:user) { nil }

    it { is_expected.to forbid_actions(:dashboard) }
  end
end
