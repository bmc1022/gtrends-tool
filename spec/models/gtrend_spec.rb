# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Gtrend, type: :model) do
  subject(:gtrend) { build(:gtrend) }

  include_examples "factory", :gtrend

  describe "attributes and indexes" do
    # Attributes
    it "has a virtual attribute :kws that is of type :text" do
      expect(gtrend).to respond_to(:kws)
      expect(described_class.attribute_types["kws"].type).to eq(:text)
    end

    # Database columns
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:guest_id).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:job_status).of_type(:string).with_options(default: "") }

    # Database indexes
    it { is_expected.to have_db_index([:user_id]) }
    it { is_expected.to have_db_index([:job_status]) }
    it { is_expected.to have_db_index([:name]).unique }
  end

  describe "associations" do
    it { is_expected.to have_many(:keywords).dependent(:destroy).inverse_of(:gtrend) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe "validations" do
    describe ":name validations" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(25) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end

    describe ":kws validations" do
      context "when gtrend is not persisted" do
        it { is_expected.to validate_presence_of(:kws) }

        it "validates that the character length of :kws is at most 5000" do
          gtrend.kws = "a" * 5000
          expect(gtrend).to be_valid

          gtrend.kws = "a" * 5001
          expect(gtrend).to be_invalid
          expect(gtrend.errors[:kws]).to include("Keywords cannot be longer than 5000 characters")
        end

        it "validates that :kws does not exceed 100 keywords" do
          gtrend.kws = Array.new(100) { "a" }
          expect(gtrend).to be_valid

          gtrend.kws = (1..101).to_a.to_s
          expect(gtrend).to be_invalid
          expect(gtrend.errors[:kws]).to include("Keyword count must not exceed 100.")
        end
      end

      context "when gtrend is persisted" do
        before { gtrend.save! }

        it { is_expected.not_to validate_presence_of(:kws) }

        it "clears :kws data on reload" do
          gtrend.reload
          expect(gtrend.kws).to be_empty
        end
      end
    end
  end

  describe "scopes" do
    describe ".seeded_trends" do
      before_all do
        @user_trend   = create(:gtrend, :created_by_user)
        @guest_trend  = create(:gtrend, :created_by_guest)
        @seeded_trend = create(:gtrend, user_id: nil, guest_id: nil)
      end

      it "returns only trends that have been created by the seed file" do
        expect(described_class.seeded_trends).to contain_exactly(@seeded_trend)
      end

      it "does not return trends that have an associated user" do
        expect(described_class.seeded_trends).not_to include(@user_trend)
      end

      it "does not return trends that have an associated guest" do
        expect(described_class.seeded_trends).not_to include(@guest_trend)
      end
    end
  end

  describe "#kws getter method" do
    let(:gtrend) { build(:gtrend, kws: "one, ONE,  One,   ,two  , three\nfour   \n  five") }

    it "returns an array of keywords split by comma and newline, with leading and trailing
        whitespace removed, and empty and duplicate entries discarded" do
      expect(gtrend.kws).to eq(["one", "two", "three", "four", "five"])
    end
  end

  describe "#highest_5y_avg" do
    before do
      create_list(:keyword, 3, gtrend:, avg_5y: rand(75))
      create(:keyword, avg_5y: 85, gtrend:)
    end

    it "returns the highest 5-year average among the associated keywords" do
      expect(gtrend.highest_5y_avg).to eq(85)
    end

    it "memoizes the result" do
      keywords = gtrend.keywords
      allow(keywords).to receive(:maximum).with(:avg_5y).and_call_original
      2.times { gtrend.highest_5y_avg }

      expect(keywords).to have_received(:maximum).with(:avg_5y).once
    end
  end
end
