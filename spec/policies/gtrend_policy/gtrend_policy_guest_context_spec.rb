# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendPolicy, type: :policy) do
  context "when user is a guest" do
    subject { described_class.new(@guest, @gtrend) }

    before_all do
      @guest = Guest.new(SecureRandom.uuid)
      @gtrend = create(:gtrend, guest_id: @guest.guest_id)
      @user_gtrend = create(:gtrend, :created_by_user)
      @other_guest_gtrend = create(:gtrend, :created_by_guest)
      @seeded_trend = create(:gtrend, :seeded)
    end

    describe "resolved scope" do
      let(:resolved_scope) { described_class::Scope.new(@guest, Gtrend.all).resolve }

      it "includes gtrend in resolved scope" do
        expect(resolved_scope).to include(@gtrend)
      end

      it "returns only the guest's gtrends and any seeded gtrends" do
        expect(resolved_scope).to contain_exactly(@gtrend, @seeded_trend)
      end

      it "does not include user gtrends" do
        expect(resolved_scope).not_to include(@user_gtrend)
      end

      it "does not include other guest's created gtrends" do
        expect(resolved_scope).not_to include(@other_guest_gtrend)
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

      it "denies any user from destroying the guest's gtrend" do
        user = create(:user)
        subject = described_class.new(user, @gtrend)

        expect(subject).to forbid_action(:destroy)
      end

      it "denies any guests not associated with the gtrend from destroying it" do
        other_guest = Guest.new(SecureRandom.uuid)
        subject = described_class.new(other_guest, @gtrend)

        expect(subject).to forbid_action(:destroy)
      end
    end
  end
end
