# frozen_string_literal: true

class FetchGtrendDataJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false # Retry logic is built into the service being called.

  # Other job statuses (e.g. "failed", "completed") are set within services/gtrends_api.
  after_enqueue do |job|
    gtrend = Gtrend.find(job.arguments.first)
    gtrend.job_status_queued!
  end

  def perform(gtrend_id, keywords)
    GtrendsApi::ProcessGtrendsData.call(gtrend_id, keywords)
  end
end
