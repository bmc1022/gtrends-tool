# frozen_string_literal: true

class Nav::NavDropdownComponent < ApplicationComponent
  erb_template <<~ERB.chomp
    <li class="<%= dropdown_classes %>">
      <%= render(Nav::NavItemComponent.new(title: @title, html_options: dropdown_options)) %>
      <ul class="dropdown-menu dropdown-menu-end">
        <%- items.each do |item| %>
          <li><%= item %></li>
        <% end %>
      </ul>
    </li>
  ERB

  renders_many :items, Nav::NavItemComponent

  def initialize(title:, toggle: true)
    super()
    @title = title
    @toggle = toggle
  end

  private

  def dropdown_options
    { role: "button", data: { "bs-toggle" => "dropdown" }, "aria-expanded" => "false" }
      .merge(Hash(toggle_option))
  end

  def toggle_option
    { class: "dropdown-toggle" } if @toggle
  end

  def dropdown_classes
    class_list = ["nav-item", "dropdown"]
    class_list << "active" if dropdown_active?
    class_list.join(" ")
  end

  def dropdown_active?
    items.any? { |item| current_page?(item.path) }
  end
end
