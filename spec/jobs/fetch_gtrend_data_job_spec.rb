# frozen_string_literal: true

require "rails_helper"

RSpec.describe(FetchGtrendDataJob, type: :job) do
  include ActiveJob::TestHelper

  let(:gtrend)   { create(:gtrend)          }
  let(:keywords) { ["keyword1", "keyword2"] }

  before { @job_arguments = [gtrend.id, keywords] }
  after  { clear_enqueued_jobs }

  include_examples "job enqueuing", queue_as: :default

  describe "disabled retry functionality" do
    it "is configured not to retry" do
      expect(described_class.sidekiq_options_hash["retry"]).to be(false)
    end
  end

  describe ":after_enqueue callback" do
    it "updates the trend's job_status to 'queued'" do
      allow(GtrendsApi::ProcessGtrendsData).to receive(:call)

      perform_enqueued_jobs do
        described_class.perform_later(*@job_arguments)
        gtrend.reload
        expect(gtrend.job_status).to eq("queued")
      end
    end
  end

  describe "#perform" do
    it "calls GtrendsApi::ProcessGtrendsData service" do
      allow(GtrendsApi::ProcessGtrendsData).to receive(:call)
      perform_enqueued_jobs { described_class.perform_later(*@job_arguments) }
      expect(GtrendsApi::ProcessGtrendsData).to have_received(:call).with(*@job_arguments)
    end
  end
end
