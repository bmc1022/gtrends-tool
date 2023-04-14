# frozen_string_literal: true

module GtrendsApi::Base
  require "json"

  GTRENDS_URL = "https://trends.google.com/trends"
  GENERAL_API_URL = "https://trends.google.com/trends/api/explore"
  OVER_TIME_URL = "https://trends.google.com/trends/api/widgetdata/multiline"

  private

  def rescue_retry(request, max_retries = 3)
    retries = 0
    begin
      request
    rescue HTTP::Error
      sleep(retries)
      (retries += 1) <= max_retries ? retry : raise
    end
  end

  def job_failed(message, return_value: nil)
    Rails.logger.error { message }
    @gtrend.update!(job_status: "failed")
    return_value
  end
end
