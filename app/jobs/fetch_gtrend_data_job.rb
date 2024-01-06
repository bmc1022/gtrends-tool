# frozen_string_literal: true

class FetchGtrendDataJob < ApplicationJob
  queue_as :default

  # 'failed' or 'done' status is set within services/gtrends_api

  after_enqueue do |job|
    gtrend.job_status_queued!
  end

  def perform(gtrend, keywords)
    GtrendsApi::ProcessGtrendsData.call(gtrend, keywords)
  end
end
