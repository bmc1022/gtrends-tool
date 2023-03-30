# frozen_string_literal: true

class GtrendsApi::GoogleCookie < GtrendsApi::Base
  def call
    fetch_google_cookie
  end

  private

  def fetch_google_cookie
    response = rescue_retry(HTTP.timeout(3).get(GTRENDS_URL))
    cookie = response["Set-Cookie"].split(";")[0]
    if cookie.present?
      cookie
    else
      Rails.logger.error { "Error fetching cookie from Google" }
      @gtrend.update(job_status: "failed")
      ""
    end
  end
end
