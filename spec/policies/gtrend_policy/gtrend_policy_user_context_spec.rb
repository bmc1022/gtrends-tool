# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendPolicy, type: :policy) do
  context "when user is a registered user" do
    subject { described_class.new(@user, @gtrend) }

    before_all do
      @user = create(:user)
      @gtrend = create(:gtrend, user: @user)
      @other_user_gtrend = create(:gtrend, :created_by_user)
      @guest_gtrend = create(:gtrend, :created_by_guest)
      @seeded_trend = create(:gtrend, :seeded)
    end

    describe "resolved scope" do
      let(:resolved_scope) { described_class::Scope.new(@user, Gtrend.all).resolve }

      it "includes gtrend in resolved scope" do
        expect(resolved_scope).to include(@gtrend)
      end

      it "returns only the user's gtrends" do
        expect(resolved_scope).to contain_exactly(@gtrend)
      end

      it "does not include other user's gtrends" do
        expect(resolved_scope).not_to include(@other_user_gtrend)
      end

      it "does not include guest created gtrends" do
        expect(resolved_scope).not_to include(@guest_gtrend)
      end

      it "does not include seeded gtrends" do
        expect(resolved_scope).not_to include(@seeded_trend)
      end
    end

    it { is_expected.to permit_actions([:index, :create]) }

    describe "destroy permissions" do
      it { is_expected.to permit_action(:destroy) }

      it "allows an admin to destroy the user's gtrend" do
        admin = create(:user, :admin)
        subject = described_class.new(admin, @gtrend)

        expect(subject).to permit_action(:destroy)
      end

      it "denies any user not associated with the gtrend from destroying it" do
        other_user = create(:user)
        subject = described_class.new(other_user, @gtrend)

        expect(subject).to forbid_action(:destroy)
      end

      it "denies any guest from destroying the user's gtrend" do
        guest = Guest.new(SecureRandom.uuid)
        subject = described_class.new(guest, @gtrend)

        expect(subject).to forbid_action(:destroy)
      end
    end
  end
end
