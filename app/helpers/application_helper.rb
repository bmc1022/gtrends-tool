module ApplicationHelper

  include Pagy::Frontend

  # Displays an inline SVG reference.
  def svg_icon(reference, class_name='icon')
    tag.svg(class: class_name) do
      concat(tag.use('xlink:href': reference))
    end
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title='')
    base_title = 'GoogleTrends Keyword Planner'
    page_title.empty? ? base_title : "#{page_title} - #{base_title}"
  end

  # Sort a trend's keyword averages from highest to lowest.
  def desc_5y_avg(trend)
    trend.keywords.sort_by(&:avg_5y).reverse!
  end

  # Convert an array of arrays to CSV format.
  def data_to_csv(data)
    require 'csv'
    data.map(&CSV.method(:generate_line)).join
  end

  # Conditional CSS classes for colorizing trend averages.
  def trend_strength(max, avg)
    rel_to_highest = avg.to_f / max
    base_class = 'trend-avg'

    str_class = case rel_to_highest
                when 0.75..1.00 then 'high-avg'
                when 0.50..0.74 then 'mid-avg'
                when 0.20..0.49 then 'low-avg'
                end

    return [base_class, str_class]
  end

end
