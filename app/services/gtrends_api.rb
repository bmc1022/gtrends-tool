class GtrendsApi < ApplicationService

  require 'json'
  
  GTRENDS_URL = 'https://trends.google.com/trends'
  GENERAL_API_URL = 'https://trends.google.com/trends/api/explore'
  OVER_TIME_URL = 'https://trends.google.com/trends/api/widgetdata/multiline'

  def initialize(gtrend, keywords)
    @gtrend = gtrend
    @keywords = JSON.parse(keywords)
    @cookie = get_google_cookie
    @over_time_req = {}
    @over_time_token = {}
  end
  
  def call
    # the first argument denotes how many of the top keywords will be used as a 
    # base to compare against each set of 5 - use 2 or 3 only
    gtrend_results(3, @keywords)
  end
  
  private
  
    def rescue_retry(req, n=3)
      retries = 0
      begin
        req
      rescue HTTP::Error
        sleep(retries)
        (retries += 1) <= n ? retry : raise
      end
    end
  
    def format_query(params)
      q = params.map do |k, v|
        k = CGI.escape(k.to_s)
        if v.is_a?(Hash)
          "#{k}=#{CGI.escape(v.to_json).gsub('%2C',',').gsub('%3A',':')}"
        else
          "#{k}=#{CGI.escape(v.to_s)}"
        end
      end
      
      return q.join('&').prepend('?')
    end
  
    def get_google_cookie
      res = rescue_retry(HTTP.timeout(3).get(GTRENDS_URL))
      if res.is_a?(HTTP::Response)
        return res['Set-Cookie'].split(';')[0]
      else
        Rails.logger.error {'Error fetching cookie from Google'}
        @gtrend.job_status = 'failed'
        return ''
      end
    end
    
    def get_api_tokens(q)
      res = gtrend_data(GENERAL_API_URL + q)
      unless res.is_a?(HTTP::Response)
        Rails.logger.error {'Error fetching Google API tokens'}
        @gtrend.job_status = 'failed'
        return
      end
      widget_data = res.to_s[4..-1] # strip leading junk characters
      widgets = JSON.parse(widget_data)['widgets']
      
      widgets.each do |widget|
        if widget['id'] == 'TIMESERIES'
          @over_time_req   = { 'req': widget['request'] }
          @over_time_token = { 'token': widget['token'] }
        end
      end
      
      return
    end
  
    def build_params(kws)
      compared_kws = []
      
      kws.each do |kw|
        kw_json = { 'keyword': kw, 'geo': 'US', 'time': 'today 5-y' }
        compared_kws << kw_json
      end
      
      params = {
        'hl': 'en-US', 'req': { 'comparisonItem': compared_kws }, 'tz': '-600'
      }

      payload_query = format_query(params)
      get_api_tokens(payload_query)
      
      return
    end
    
    def gtrend_data(url, **kwargs)
      rescue_retry(HTTP.timeout(3).headers(cookie: @cookie).get(url, **kwargs))
    end
    
    def over_time_averages(kws, data)
      averages = data['default']['averages']
      return kws.zip(averages).to_h
    end
    
    def interest_over_time_data(kws)
      build_params(kws) # assign interest over time params
      
      hl_tz = { 'hl': 'en-US', 'tz': '-600' }
      params_with_token = @over_time_req.merge(@over_time_token).merge(hl_tz)
      
      q = format_query(params_with_token)
      res = rescue_retry(HTTP.timeout(5).get(OVER_TIME_URL + q))
      over_time_data = res.to_s[6..-1] # strip leading junk characters
      unless res.is_a?(HTTP::Response)
        Rails.logger.error {'Error fetching Interest Over Time data'}
        @gtrend.job_status = 'failed'
        return {}
      end

      return over_time_averages(kws, JSON.parse(over_time_data))
    end
  
    def create_keywords(list)
      kw_params = list.map do |k, v|
        v ||= 0 # assign v to 0 if nil
        { gtrend: @gtrend, kw: k, avg_5y: v }
      end
      
      @gtrend.keywords.build(kw_params)
      
      # create all keywords using the same database connection
      Gtrend.transaction do 
        @gtrend.save!
      end
    end
  
    def find_top(n, kws)
      # compare first five
      top_kws = interest_over_time_data(kws.take(5)).max_by(n){|k,v| v}.to_h

      # cycle through each consecutive slice of [5-n] keywords (since there's a 
      # 5 keyword limit), comparing to and overwriting the previous top (n)
      # there's a 1 second pause between each request to avoid rate limit
      kws.drop(5).each_slice(5 - n) do |slice|
        sleep(1)
        res = interest_over_time_data(top_kws.keys + slice)
        top_kws = res.max_by(n){|k,v| v}.to_h
      end
      
      return top_kws
    end
    
    # once the overall top [n] keywords are found from the list, use those as a 
    # base and cycle through the remaining keywords again for the full results
    def gtrend_results(n=3, kws)
      top_kws = find_top(n, kws)
      remaining_kws = kws - top_kws.keys
      results = {}
      
      remaining_kws.each_slice(5 - n) do |slice|
        sleep(1)
        results.merge!(interest_over_time_data(top_kws.keys + slice))
      end
      
      create_keywords(results)
      
      return
    end
    
end
