# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  # Returns the full title on a per-page basis.
  def full_title(page_title = "")
    base_title = "GoogleTrends Keyword Planner"
    page_title.blank? ? base_title : "#{page_title} - #{base_title}"
  end

  # Checks if an asset exists within the application.
  def asset_exists?(asset_path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include?(asset_path)
    else
      Rails.application.assets_manifest.assets[asset_path].present?
    end
  end

  # Displays an inline SVG reference.
  def svg_icon(reference, class_name = "")
    tag.svg(class: "icon #{class_name}".strip) { concat(tag.use("xlink:href": reference)) }
  end

  # Sort a trend's keyword averages from highest to lowest.
  def desc_5y_avg(trend)
    trend.keywords.sort_by(&:avg_5y).reverse!
  end

  # Convert an array of arrays to CSV format.
  def data_to_csv(data)
    require("csv")
    data.map(&CSV.method(:generate_line)).join
  end

  # Conditional CSS classes for colorizing trend averages.
  def trend_strength(max, avg)
    rel_to_highest = avg.to_f / max
    base_class = "trend-avg"

    str_class =
      case rel_to_highest
      when 0.75..1.00 then "high-avg"
      when 0.50..0.74 then "mid-avg"
      when 0.20..0.49 then "low-avg"
      end

    [base_class, str_class]
  end
end
