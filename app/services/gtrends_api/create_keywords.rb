# frozen_string_literal: true

class GtrendsApi::CreateKeywords < ApplicationService
  def initialize(gtrend, list)
    super()
    @gtrend = gtrend
    @list = list
  end

  def call
    create_keywords
  end

  private

  def create_keywords
    @gtrend.keywords.build(keyword_params)

    # Create all keywords using the same database connection.
    Gtrend.transaction do
      @gtrend.job_status = "done"
      @gtrend.save!
    end
  end

  def keyword_params
    @list.map { |keyword, average| { gtrend: @gtrend, term: keyword, avg_5y: average || 0 } }
  end
end
