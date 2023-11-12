# frozen_string_literal: true

class Alerts::ErrorAlertComponent < ApplicationComponent
  erb_template <<~ERB.chomp
    <% if @resource.errors.any? %>
      <div class="d-flex alert alert-danger" role="alert">
        <div class="alert-icon">
          <%= render(SvgIconComponent.new(reference: "#error")) %>
        </div>
        <div>
          <h3><%= heading_text %></h3>
          <ul class="mb-0">
            <% primary_errors.each do |error_message| %>
              <li><%= error_message %></li>
            <% end %>
          </ul>
        </div>
      </div>
    <% end %>
  ERB

  def initialize(resource)
    super()
    @resource = resource
  end

  private

  # Returns a list containing the first error message from each validated field.
  def primary_errors
    @resource.errors.messages.map { |_, errors| errors.first }
  end

  def error_count
    primary_errors.size
  end

  def heading_text
    if error_count > 1
      "There were #{error_count} errors with your submission:"
    else
      "There was an error with your submission:"
    end
  end
end
