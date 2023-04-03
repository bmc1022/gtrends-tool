# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GtrendsApi::GoogleAuth, type: :service) do
  let(:gtrend)              { create(:gtrend)              }
  let(:google_auth_service) { described_class.call(gtrend) }

  describe "#call" do
    context "when fetching the Google cookie is successful" do
      it "returns a valid Google cookie" do
        VCR.use_cassette("gtrends_api/google_cookie_success") do
          expect(google_auth_service).not_to be_empty
          expect(google_auth_service).to start_with("NID=")
        end
      end
    end

    # context "when fetching the Google cookie fails" do
    #   let(:gtrend)        { create(:gtrend) }
    #   let(:google_cookie) { instance_double(described_class) }

    #   before do
    #     allow(google_cookie_service).to receive(:rescue_retry).and_return(nil)
    #     # allow(google_cookie).to receive(:gtrend).and_return(gtrend)
    #   end

    #   it "logs an error message and updates the job_status to 'failed'" do
    #     # expect(Rails.logger).to have_received(:error).with("Error fetching cookie from Google")
    #     # expect { google_cookie_service.call }.to change { gtrend.reload.job_status }
    #                                            .from("queued").to("failed")
    #   end
    # end
  end
end
