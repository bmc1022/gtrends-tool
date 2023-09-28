# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  describe "#full_title" do
    let(:base_title) { "GoogleTrends Keyword Planner" }

    context "when a page title is not provided" do
      it "returns the base title" do
        expect(helper.full_title).to eq(base_title)
      end
    end

    context "when the provided page title is an empty string" do
      it "returns the base title" do
        expect(helper.full_title("   ")).to eq(base_title)
      end
    end

    context "when a page title is provided" do
      let(:page_title) { "Test Title" }

      it "returns the full title with both the page title and the base title" do
        expect(helper.full_title(page_title)).to eq("#{page_title} - #{base_title}")
      end
    end
  end

  describe "#asset_exists?" do
    let(:existing_asset_path)     { "application.js"   }
    let(:non_existing_asset_path) { "non_existing.png" }

    context "when assets are precompiled" do
      before { allow(Rails.configuration.assets).to receive(:compile).and_return(true) }

      it { expect(helper.asset_exists?(existing_asset_path)).to be(true) }
      it { expect(helper.asset_exists?(non_existing_asset_path)).to be(false) }
    end

    context "when assets are not precompiled" do
      before do
        allow(Rails.configuration.assets).to receive(:compile).and_return(false)
        allow(Rails.application.assets_manifest.assets).to receive(:[])
          .with(existing_asset_path).and_return(true)
        allow(Rails.application.assets_manifest.assets).to receive(:[])
          .with(non_existing_asset_path).and_return(false)
      end

      it { expect(helper.asset_exists?(existing_asset_path)).to be(true) }
      it { expect(helper.asset_exists?(non_existing_asset_path)).to be(false) }
    end
  end

  describe "#svg_icon" do
    let(:reference) { "#icon-example" }

    it "returns an inline SVG reference" do
      expected_html = '<svg class="icon"><use xlink:href="#icon-example"></use></svg>'
      expect(helper.svg_icon(reference)).to eq(expected_html)
    end

    context "when a custom CSS class is provided" do
      let(:additional_classes) { "custom-class" }

      it "returns an inline SVG reference with the given CSS class" do
        expected_html =
          '<svg class="icon custom-class"><use xlink:href="#icon-example"></use></svg>'
        expect(helper.svg_icon(reference, additional_classes:)).to eq(expected_html)
      end
    end

    context "when multiple CSS classes are provided" do
      let(:additional_classes) { ["class1", "class2"] }

      it "returns an inline SVG reference with all given CSS classes" do
        expected_html =
          '<svg class="icon class1 class2"><use xlink:href="#icon-example"></use></svg>'
        expect(helper.svg_icon(reference, additional_classes:)).to eq(expected_html)
      end
    end
  end

  describe "#data_to_csv" do
    let(:data) { [["keyword1", 10], ["keyword2", 20], ["keyword3", 30]] }

    it "converts an array of arrays into CSV format" do
      expect(helper.data_to_csv(data)).to eq("keyword1,10\nkeyword2,20\nkeyword3,30\n")
    end
  end
end
