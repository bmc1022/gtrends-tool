# frozen_string_literal: true

class GtrendsApi::FetchGtrendsData < ApplicationService
  include GtrendsApi::Base

  def initialize(keywords)
    super()
    @keywords = keywords
  end

  def call
    interest_over_time_data
  end

  private

  def interest_over_time_data
    widget_query = GtrendsApi::GenerateQuery.call(@keywords)
    params_with_token = GtrendsApi::FetchWidgetParams.call(widget_query)
    data_query = GtrendsApi::GenerateQuery.new(@keywords).build_query(params_with_token)
    response = rescue_retry(HTTP.timeout(5).get(OVER_TIME_URL + data_query))
    job_failed("Error fetching trend data", return_value: {}) unless response.is_a?(HTTP::Response)

    over_time_averages(@keywords, JSON.parse(response.to_s[6..])) # Strip leading junk characters.
  end

  def over_time_averages(keywords, data)
    averages = data["default"]["averages"]
    keywords.zip(averages).to_h
  end
end
