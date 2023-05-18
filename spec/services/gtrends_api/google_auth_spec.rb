# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendsApi::GoogleAuth, type: :service) do
  subject { described_class }

  let(:gtrend)              { build(:gtrend)              }
  let(:google_auth_service) { described_class.new(gtrend) }

  it { is_expected.to have_constant(:COOKIE_EXPIRATION).with_value(2_592_000) }

  describe "#cookie", :with_caching do
    context "when the cookie is expired" do
      before do
        Rails.cache.write("google_auth_cookie_timestamp",
                          (described_class::COOKIE_EXPIRATION + 1).seconds.ago)
      end

      it "fetches a new authentication cookie from Google" do
        VCR.use_cassette("gtrends_api/google_cookie") do
          expect { google_auth_service.cookie }.to change { Rails.cache.read("google_auth_cookie") }
            .from(nil).to(/^NID=/)
        end
      end
    end

    context "when the cookie is not expired" do
      before do
        Rails.cache.write("google_auth_cookie", "NID=511=abc123_TEST")
        Rails.cache.write("google_auth_cookie_timestamp", Time.current)
      end

      it "returns the cached version of the cookie" do
        expect(google_auth_service.cookie).to eq("NID=511=abc123_TEST")
      end
    end
  end

  # private methods

  describe "#cookie_timestamp", :with_caching do
    context "when there is a cached timestamp" do
      before { Rails.cache.write("google_auth_cookie_timestamp", Time.current) }

      it "returns the cached timestamp" do
        expect(google_auth_service.send(:cookie_timestamp)).to eq(
          Rails.cache.read("google_auth_cookie_timestamp")
        )
      end
    end

    context "when there is no cached timestamp" do
      it "returns 0" do
        expect(google_auth_service.send(:cookie_timestamp)).to eq(0)
      end
    end
  end

  describe "#cookie_expired?", :with_caching do
    context "when the cookie is expired" do
      before do
        Rails.cache.write("google_auth_cookie_timestamp",
                          (described_class::COOKIE_EXPIRATION + 1).seconds.ago)
      end

      it "returns true" do
        expect(google_auth_service.send(:cookie_expired?)).to be(true)
      end
    end

    context "when the cookie is not expired" do
      before { Rails.cache.write("google_auth_cookie_timestamp", Time.current) }

      it "returns false" do
        expect(google_auth_service.send(:cookie_expired?)).to be(false)
      end
    end
  end
end
