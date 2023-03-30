# frozen_string_literal: true

class GtrendsApi::Base < ApplicationService
  require "json"

  GTRENDS_URL = "https://trends.google.com/trends"
  GENERAL_API_URL = "https://trends.google.com/trends/api/explore"
  OVER_TIME_URL = "https://trends.google.com/trends/api/widgetdata/multiline"

  private

  def rescue_retry(request, n = 3)
    retries = 0
    begin
      request
    rescue HTTP::Error
      sleep(retries)
      (retries += 1) <= n ? retry : raise
    end
  end
end
