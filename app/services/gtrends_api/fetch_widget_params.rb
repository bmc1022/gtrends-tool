# frozen_string_literal: true

class GtrendsApi::FetchWidgetParams < ApplicationService
  include GtrendsApi::Base

  COOKIE_EXPIRATION = 2_592_000 # 1 month

  def self.cookie(gtrend)
    @cookie ||= nil
    @cookie_timestamp ||= nil

    if @cookie.nil? || (Time.current - @cookie_timestamp) > COOKIE_EXPIRATION
      @cookie = GtrendsApi::GoogleAuth.call(gtrend)
      @cookie_timestamp = Time.current
    end
    @cookie
  end

  def initialize(gtrend, query)
    super()
    @gtrend = gtrend
    @query = query
  end

  def call
    time_series_params
  end

  private

  def cookie
    self.class.cookie(@gtrend)
  end

  def raw_widgets_data
    response = rescue_retry(HTTP.timeout(3).headers(cookie:).get(GENERAL_API_URL + @query))
    job_failed("Error fetching Google API tokens") unless response.is_a?(HTTP::Response)
    JSON.parse(response.to_s[4..])["widgets"] # Strip leading junk characters.
  end

  def time_series_params
    time_series = raw_widgets_data.find { |widget| widget["id"] == "TIMESERIES" }
    { req: time_series["request"], token: time_series["token"], hl: "en-US", tz: "-600" }
  end
end
