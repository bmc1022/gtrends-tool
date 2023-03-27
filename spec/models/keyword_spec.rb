# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Keyword, type: :model) do
  subject(:keyword) { build(:keyword) }

  include_examples "factory", :keyword

  describe "attributes and indexes" do
    # Database columns
    it { is_expected.to have_db_column(:term).of_type(:string) }
    it { is_expected.to have_db_column(:avg_5y).of_type(:integer).with_options(default: 0) }

    # Database indexes
    it { is_expected.to have_db_index([:gtrend_id]) }
    it { is_expected.to have_db_index([:term, :gtrend_id]).unique }
  end

  describe "associations" do
    it { is_expected.to belong_to(:gtrend).inverse_of(:keywords) }
  end

  describe "validations" do
    describe ":term validations" do
      it { is_expected.to validate_presence_of(:term) }

      it do
        is_expected.to validate_uniqueness_of(:term).case_insensitive.scoped_to(:gtrend_id)
                                                    .with_message(/'*' has already been taken/)
      end
    end
  end

  describe "scopes" do
    describe ".desc_5y_avg" do
      let!(:keyword_1) { create(:keyword, avg_5y: 10) }
      let!(:keyword_2) { create(:keyword, avg_5y: 30) }
      let!(:keyword_3) { create(:keyword, avg_5y: 20) }

      it "returns keywords ordered by descending 5-year average" do
        expect(described_class.desc_5y_avg).to eq([keyword_2, keyword_3, keyword_1])
      end
    end
  end
end
