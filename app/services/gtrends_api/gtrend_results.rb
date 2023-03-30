# frozen_string_literal: true

class GtrendsApi::GtrendResults < GtrendsApi::Base
  def initialize(gtrend, keywords)
    @gtrend = gtrend
    @keywords = keywords
    @cookie = GtrendsApi::GoogleCookie.call
    @over_time_request = {}
    @over_time_token = {}
  end

  def call
    # The first argument denotes how many of the top keywords will be used as a
    # base to compare against each set of 5 - use 2 or 3 only.
    gtrend_results(3, @keywords)
  end

  private

  def format_query(params)
    query = params.map do |k, v|
      k = CGI.escape(k.to_s)
      if v.is_a?(Hash)
        "#{k}=#{CGI.escape(v.to_json).gsub('%2C', ',').gsub('%3A', ':')}"
      else
        "#{k}=#{CGI.escape(v.to_s)}"
      end
    end

    query.join("&").prepend("?")
  end

  def api_tokens(query)
    response = gtrend_data(GENERAL_API_URL + query)
    unless response.is_a?(HTTP::Response)
      Rails.logger.error { "Error fetching Google API tokens" }
      @gtrend.update(job_status: "failed")
      return
    end
    widget_data = response.to_s[4..-1] # Strip leading junk characters.
    widgets = JSON.parse(widget_data)["widgets"]

    widgets.each do |widget|
      if widget["id"] == "TIMESERIES"
        @over_time_request = { req: widget["request"] }
        @over_time_token   = { token: widget["token"] }
      end
    end

    nil
  end

  def build_params(kws)
    compared_kws = []

    kws.each do |kw|
      kw_json = { keyword: kw, geo: "US", time: "today 5-y" }
      compared_kws << kw_json
    end

    params = { hl: "en-US", req: { comparisonItem: compared_kws }, tz: "-600" }

    payload_query = format_query(params)
    api_tokens(payload_query)

    nil
  end

  def gtrend_data(url, **kwargs)
    rescue_retry(HTTP.timeout(3).headers(cookie: @cookie).get(url, **kwargs))
  end

  def over_time_averages(kws, data)
    averages = data["default"]["averages"]
    kws.zip(averages).to_h
  end

  def interest_over_time_data(kws)
    build_params(kws) # Assign interest over time params.

    hl_tz = { hl: "en-US", tz: "-600" }
    params_with_token = @over_time_req.merge(@over_time_token).merge(hl_tz)

    q = format_query(params_with_token)
    res = rescue_retry(HTTP.timeout(5).get(OVER_TIME_URL + q))
    over_time_data = res.to_s[6..-1] # Strip leading junk characters.
    unless res.is_a?(HTTP::Response)
      Rails.logger.error { "Error fetching Interest Over Time data" }
      @gtrend.update(job_status: "failed")
      return {}
    end

    over_time_averages(kws, JSON.parse(over_time_data))
  end

  def create_keywords(list)
    kw_params = list.map do |k, v|
      v ||= 0 # Assign 0 if nil.
      { gtrend: @gtrend, term: k, avg_5y: v }
    end

    @gtrend.keywords.build(kw_params)

    # Create all keywords using the same database connection.
    Gtrend.transaction do
      @gtrend.job_status = "done"
      @gtrend.save!
    end
  end

  def find_top(count, kws)
    # Compare first five.
    top_kws = interest_over_time_data(kws.take(5)).max_by(count) { |_k, v| v }.to_h

    # Cycle through each consecutive slice of [5-n] keywords (since there's a
    # 5 keyword limit), comparing to and overwriting the previous top (n).
    # There's a 1 second pause between each request to avoid rate limit.
    kws.drop(5).each_slice(5 - count) do |slice|
      sleep(1)
      res = interest_over_time_data(top_kws.keys + slice)
      top_kws = res.max_by(count) { |_k, v| v }.to_h
    end

    top_kws
  end

  # Once the overall top [n] keywords are found from the list, use those as a
  # base and cycle through the remaining keywords again for the full results.
  def gtrend_results(n = 3, kws)
    top_kws = find_top(n, kws)
    remaining_kws = kws.size > n ? kws - top_kws.keys : kws
    results = {}

    remaining_kws.each_slice(5 - n) do |slice|
      sleep(1)
      results.merge!(interest_over_time_data(top_kws.keys + slice))
    end

    create_keywords(results)

    nil
  end
end
