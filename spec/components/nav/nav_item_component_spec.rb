# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Nav::NavItemComponent, type: :component) do
  subject(:rendered_component) { render_inline(component_instance) }

  let(:component_instance) { described_class.new(title:, path:, html_options:) }
  let(:title)              { "Test Link"                                       }
  let(:path)               { "/test_path"                                      }
  let(:html_options)       { { class: "extra-class" }                          }

  it "renders the nav item with title and path" do
    expect(rendered_component.css("a").text).to include(title)
    expect(rendered_component.css("a").attribute("href").value).to eq(path)
  end

  describe "active class assignment" do
    context "when the current page matches the path" do
      before { allow(component_instance).to receive(:current_page?).and_return(true) }

      it "adds the 'active' class" do
        expect(rendered_component.css("a").attribute("class").value).to include("active")
      end
    end

    context "when the current page does not match the path" do
      before { allow(component_instance).to receive(:current_page?).and_return(false) }

      it "does not add the 'active' class" do
        expect(rendered_component.css("a").attribute("class").value).not_to include("active")
      end
    end
  end

  describe "HTML options" do
    it "includes additional classes passed in through the html_options hash" do
      expect(rendered_component.css("a").attribute("class").value).to eq(
        "d-flex align-items-center nav-link extra-class"
      )
    end
  end

  describe "icon rendering" do
    let(:icon_ref) { { reference: "#test-icon" } }
    let(:component_instance) do
      described_class.new(title:, path:, html_options:).tap { |item| item.with_icon(**icon_ref) }
    end

    it "prepends an icon to the nav item" do
      expect(rendered_component.css("a svg use").attribute("xlink:href").value).to eq("#test-icon")
    end
  end
end
