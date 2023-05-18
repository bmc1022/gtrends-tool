# frozen_string_literal: true

class GtrendsApi::GoogleAuth
  include GtrendsApi::Base

  COOKIE_EXPIRATION = 2_592_000 # 1 month

  def initialize(gtrend)
    @gtrend = gtrend
  end

  def cookie
    fetch_google_cookie if cookie_expired?
    Rails.cache.read("google_auth_cookie")
  end

  private

  def cookie_timestamp
    Rails.cache.read("google_auth_cookie_timestamp") || 0
  end

  def cookie_expired?
    (Time.current - cookie_timestamp).to_i > COOKIE_EXPIRATION
  end

  def fetch_google_cookie
    response = rescue_retry(HTTP.timeout(3).get(GTRENDS_URL))
    cookie = response["Set-Cookie"].split(";")[0]

    if cookie.present?
      Rails.cache.write("google_auth_cookie", cookie)
      Rails.cache.write("google_auth_cookie_timestamp", Time.current)
    else
      job_failed("Error fetching cookie from Google", return_value: "")
    end
  end
end
