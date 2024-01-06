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
end
