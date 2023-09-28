# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SvgIconComponent, type: :component) do
  describe "#render" do
    context "with an icon reference only" do
      it "renders the SVG icon" do
        render_inline(described_class.new(reference: "#icon-reference"))

        use_elements = page.all("use")
        matching_elements = use_elements.select { |el| el["xlink:href"] == "#icon-reference" }

        expect(page).to have_css("svg.icon")
        expect(matching_elements).not_to be_empty
      end
    end

    context "with additional classes" do
      it "renders the SVG icon with a single additional classes" do
        render_inline(described_class.new(reference: "#icon-reference",
                                          additional_classes: "extra-class"))

        expect(page).to have_css("svg.icon.extra-class")
      end

      it "renders the SVG icon with multiple additional classes" do
        render_inline(described_class.new(reference: "#icon-reference",
                                          additional_classes: "class1 class2"))

        expect(page).to have_css("svg.icon.class1.class2")
      end
    end
  end
end
