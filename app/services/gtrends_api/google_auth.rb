# frozen_string_literal: true

class GtrendsApi::GoogleAuth < ApplicationService
  include GtrendsApi::Base

  def initialize(gtrend)
    super()
    @gtrend = gtrend
  end

  def call
    fetch_google_cookie
  end

  private

  def fetch_google_cookie
    response = rescue_retry(HTTP.timeout(3).get(GTRENDS_URL))
    cookie = response["Set-Cookie"].split(";")[0]

    cookie.presence || job_failed("Error fetching cookie from Google", return_value: "")
  end
end
