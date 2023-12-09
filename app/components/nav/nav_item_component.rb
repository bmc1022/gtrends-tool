# frozen_string_literal: true

# Bootstrap-compatible navigation link with a dynamic "active" class which is added when
# the current page matches the provided path.
class Nav::NavItemComponent < ApplicationComponent
  erb_template <<~ERB.chomp
    <%= link_to(@path, html_options_with_classes) do %>
      <%= icon %>
      <%= @title %>
    <% end %>
  ERB

  attr_reader :path

  renders_one :icon, SvgIconComponent

  def initialize(title: nil, path: "#", html_options: {})
    super()
    @title = title
    @path = path
    @html_options = html_options
  end

  private

  def page_active?
    current_page?(@path)
  end

  def nav_link_classes
    class_list = ["d-flex", "align-items-center", "nav-link"]
    class_list << "active" if page_active?
    class_list
  end

  def html_options_with_classes
    @html_options[:class] = (nav_link_classes + @html_options[:class].to_s.split).join(" ")
    @html_options
  end
end
