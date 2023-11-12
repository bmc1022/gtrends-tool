# frozen_string_literal: true

class Alerts::FlashAlertComponent < ApplicationComponent
  erb_template <<~ERB.chomp
    <% flash.each do |type, message| %>
      <div class="<%= alert_classes %> alert-<%= type %>" role="alert">
        <div class="alert-icon">
          <%= render(SvgIconComponent.new(reference: alert_icon(type))) %>
        </div>
        <span><%= message %></span>
        <div class="ms-auto close-alert">
          <button class="close-btn" type="button" data-bs-dismiss="alert" aria-label="Close">
            <%= render(SvgIconComponent.new(reference: "#close")) %>
          </button>
        </div>
      </div>
    <% end %>
  ERB

  private

  def alert_classes
    ["d-flex", "alert", "fade", "show"].join(" ")
  end

  def alert_icon(type)
    case type.to_sym
    when :success         then "#check-circle"
    when :notice          then "#info"
    when :warning, :alert then "#warning"
    end
  end
end
