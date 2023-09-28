# frozen_string_literal: true

# Displays an inline SVG reference.
class SvgIconComponent < ApplicationComponent
  erb_template <<~ERB.chomp
    <svg class="<%= svg_classes %>"><use xlink:href="<%= @reference %>"></use></svg>
  ERB

  def initialize(reference:, additional_classes: "")
    super()
    @reference = reference
    @additional_classes = Array.wrap(additional_classes)
  end

  private

  def svg_classes
    "icon #{@additional_classes.join(' ')}".strip
  end
end
