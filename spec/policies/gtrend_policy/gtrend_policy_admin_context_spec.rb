# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendPolicy, type: :policy) do
  context "as an administrator" do
    subject { described_class.new(@admin, @gtrend) }

    before_all do
      @admin = create(:user, :admin)
      @gtrend = create(:gtrend, user: @admin)
      @user_gtrend  = create(:gtrend, :created_by_user)
      @guest_gtrend = create(:gtrend, :created_by_guest)
      @seeded_trend = create(:gtrend, :seeded)
    end

    describe "resolved scope" do
      let(:resolved_scope) { described_class::Scope.new(@admin, Gtrend.all).resolve }

      it "includes gtrend in resolved scope" do
        expect(resolved_scope).to include(@gtrend)
      end

      it "returns all gtrends" do
        expect(resolved_scope).to contain_exactly(@gtrend, @user_gtrend, @guest_gtrend, @seeded_trend)
        expect(resolved_scope).to eq(Gtrend.all)
      end
    end

    it { is_expected.to permit_actions([:index, :create]) }

    describe "destroy permissions" do
      it { is_expected.to permit_action(:destroy) }

      it "allows an admin to destroy a user's gtrend" do
        subject = described_class.new(@admin, @user_gtrend)

        expect(subject).to permit_action(:destroy)
      end

      it "allows an admin to destroy a guest's gtrend" do
        subject = described_class.new(@admin, @guest_gtrend)

        expect(subject).to permit_action(:destroy)
      end

      it "allows an admin to destroy a seeded gtrend" do
        subject = described_class.new(@admin, @seeded_trend)

        expect(subject).to permit_action(:destroy)
      end
    end
  end
end
