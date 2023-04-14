# frozen_string_literal: true

class GtrendsApi::GenerateQuery < ApplicationService
  def initialize(keywords)
    super()
    @keywords = keywords
  end

  def call
    payload_query
  end

  def build_query(params)
    params.map { |key, value| format_query_params(key, value) }.join("&").prepend("?")
  end

  private

  def payload_query
    build_query(build_params)
  end

  def build_params
    compared_keywords = @keywords.map { |keyword| { keyword:, geo: "US", time: "today 5-y" } }
    { hl: "en-US", req: { comparisonItem: compared_keywords }, tz: "-600" }
  end

  def format_query_params(key, value)
    escaped_key = CGI.escape(key.to_s)

    if value.is_a?(Hash)
      "#{escaped_key}=#{CGI.escape(value.to_json).gsub('%2C', ',').gsub('%3A', ':')}"
    else
      "#{escaped_key}=#{CGI.escape(value.to_s)}"
    end
  end
end
