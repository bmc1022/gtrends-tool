# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SvgIconComponent, type: :component) do
  subject(:rendered_icon) { render_inline(described_class.new(reference:, additional_classes:)) }

  let(:reference)          { "#icon-reference" }
  let(:additional_classes) { ""                }

  context "with an icon reference only" do
    it "renders the SVG icon" do
      expect(rendered_icon).to have_css("svg.icon")
      expect(rendered_icon.css("use").attribute("xlink:href").value).to eq("#icon-reference")
    end
  end

  context "with an additional class" do
    let(:additional_classes) { "extra-class" }

    it "renders the SVG icon with a single additional classes" do
      expect(rendered_icon.css("svg").attribute("class").value).to eq("icon extra-class")
    end
  end

  context "with multiple additional classes" do
    let(:additional_classes) { "class1 class2" }

    it "renders the SVG icon with multiple additional classes" do
      expect(rendered_icon.css("svg").attribute("class").value).to eq("icon class1 class2")
    end
  end
end
