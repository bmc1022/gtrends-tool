# frozen_string_literal: true

class GtrendsApi::FetchWidgetParams < ApplicationService
  include GtrendsApi::Base

  def initialize(query)
    super()
    @query = query
  end

  def call
    time_series_params
  end

  private

  def widgets_data_request
    HTTP.timeout(3).headers(cookie: GtrendsApi::GoogleAuth.new.cookie).get(GENERAL_API_URL + @query)
  end

  def widgets_data
    response = rescue_retry(widgets_data_request)
    job_failed("Error fetching Google API tokens") unless response.is_a?(HTTP::Response)
    JSON.parse(response.to_s[4..])["widgets"] # Strip leading junk characters.
  end

  def time_series_params
    time_series = widgets_data.find { |widget| widget["id"] == "TIMESERIES" }
    { req: time_series["request"], token: time_series["token"], hl: "en-US", tz: "-600" }
  end
end
