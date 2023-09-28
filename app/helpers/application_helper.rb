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
    rails_app = Rails.application

    if Rails.configuration.assets.compile
      rails_app.precompiled_assets.include?(asset_path)
    else
      rails_app.assets_manifest.assets[asset_path].present?
    end
  end

  # Displays an inline SVG reference.
  def svg_icon(reference, additional_classes: "")
    render(SvgIconComponent.new(reference:, additional_classes:))
  end

  # Convert an array of arrays to CSV format.
  def data_to_csv(data)
    require("csv")
    data.map { |row| CSV.generate_line(row) }.join
  end
end
