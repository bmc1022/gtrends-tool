# frozen_string_literal: true

class FetchGtrendDataJob < ApplicationJob
  queue_as :default

  # 'failed' or 'done' status is set within services/gtrends_api

  after_enqueue do |job|
    gtrend = job.arguments.first
    gtrend.job_status = "queued"
    gtrend.save!
  end

  def perform(gtrend, keywords)
    GtrendsApi.call(gtrend, keywords)
  end
end
