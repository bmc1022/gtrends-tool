# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendHelper, type: :helper) do
  describe "#clipboard_kw_data" do
    let(:trend) { build(:gtrend) }

    before { create_list(:keyword, 3, :with_averages, gtrend: trend) }

    it "returns a CSV formatted list of keywords and their 5-year average" do
      expect(helper.clipboard_kw_data(trend)).to eq("kw3,30\nkw2,20\nkw1,10\n")
    end
  end

  describe "#trend_strength" do
    context "when average is between 0.75 and 1.00 of the maximum" do
      it { expect(helper.trend_strength(100, 100)).to eq(["trend-avg", "high-avg"]) }
      it { expect(helper.trend_strength(100, 75)).to eq(["trend-avg", "high-avg"]) }
    end

    context "when average is between 0.50 and 0.74 of the maximum" do
      it { expect(helper.trend_strength(100, 74)).to eq(["trend-avg", "mid-avg"]) }
      it { expect(helper.trend_strength(100, 50)).to eq(["trend-avg", "mid-avg"]) }
    end

    context "when average is between 0.20 and 0.49 of the maximum" do
      it { expect(helper.trend_strength(100, 49)).to eq(["trend-avg", "low-avg"]) }
      it { expect(helper.trend_strength(100, 20)).to eq(["trend-avg", "low-avg"]) }
    end

    context "when average is below 0.20 of the maximum" do
      it { expect(helper.trend_strength(100, 19)).to eq(["trend-avg", nil]) }
      it { expect(helper.trend_strength(100, 0)).to eq(["trend-avg", nil]) }
    end
  end
end
