class FetchGtrendDataJob < ApplicationJob
  queue_as :default

  def perform(gtrend, keywords)
    GtrendsApi.call(gtrend, keywords)
  end
end
