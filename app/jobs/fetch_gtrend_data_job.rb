class FetchGtrendDataJob < ApplicationJob
  queue_as :default
  
  # failed status is set within services/gtrends_api
  
  after_enqueue do |job| 
    gtrend = job.arguments.first
    gtrend.job_status = 'queued'
  end  
  
  after_perform do |job|
    gtrend = job.arguments.first
    gtrend.job_status = 'finished'
  end

  def perform(gtrend, keywords)
    GtrendsApi.call(gtrend, keywords)
  end
end
