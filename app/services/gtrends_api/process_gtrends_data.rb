# frozen_string_literal: true

# This service sorts up to 100 keywords by their 5-year search popularity averages, bypassing
# Google Trends' 5-keyword comparison limit. It starts with the first five keywords, selects the
# top three by average, and iteratively compares them with consecutive pairs until the top three
# are found. Then, it assesses the remaining keywords' relative strength compared to the top
# three, and sorts the list by averages for the final result.

class GtrendsApi::ProcessGtrendsData < ApplicationService
  include GtrendsApi::Base

  def initialize(gtrend, keywords)
    super()
    @gtrend = gtrend
    @keywords = keywords
  end

  def call
    gtrend_results
  end

  private

  def find_top_three(keywords)
    # Compare first five.
    first_five = GtrendsApi::FetchGtrendsData.call(@gtrend, keywords.take(5))
    top_keywords = first_five.max_by(3) { |_k, v| v }.to_h

    # Cycle through each consecutive slice of two keywords, comparing to and overwriting the
    # previous top three.
    # There's a 1 second pause between each request to avoid rate limit.
    keywords.drop(5).each_slice(2) do |slice|
      sleep(1)
      response = GtrendsApi::FetchGtrendsData.call(@gtrend, top_keywords.keys + slice)
      top_keywords = response.max_by(3) { |_k, v| v }.to_h
    end

    top_keywords
  end

  # Once the overall top three keywords are found from the list, use those as a base and cycle
  # through the remaining keywords again for the full results.
  def gtrend_results
    top_keywords = find_top_three(@keywords)
    remaining_keywords = @keywords.size > 3 ? @keywords - top_keywords.keys : @keywords
    results = {}

    remaining_keywords.each_slice(2) do |slice|
      sleep(1)
      results.merge!(GtrendsApi::FetchGtrendsData.call(@gtrend, top_keywords.keys + slice))
    end

    GtrendsApi::CreateKeywords.call(@gtrend, results)
  end
end
