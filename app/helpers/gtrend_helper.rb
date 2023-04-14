# frozen_string_literal: true

module GtrendHelper
  # Returns a CSV formatted list of keywords and their 5-year average for the given trend.
  def clipboard_kw_data(trend)
    data_to_csv(trend.keywords.desc_5y_avg.pluck(:term, :avg_5y))
  end

  # Conditional CSS classes for colorizing trend averages.
  def trend_strength(max, avg)
    str_class =
      case (avg.to_f / max)
      when 0.75..1.00 then "high-avg"
      when 0.50..0.74 then "mid-avg"
      when 0.20..0.49 then "low-avg"
      end

    ["trend-avg", str_class]
  end
end
