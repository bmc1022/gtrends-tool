# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Nav::NavDropdownComponent, type: :component) do
  subject(:rendered_component) { render_inline(component_instance) }

  let(:component_instance) { described_class.new(title:, toggle:) }
  let(:title)              { "Test Title"                         }
  let(:toggle)             { true                                 }

  it "renders the dropdown with the correct title" do
    expect(rendered_component.css("li.nav-item.dropdown").to_html).to include(title)
  end

  describe "active state" do
    let(:dropdown_item) { { path: "/current_page", title: "Current Page" } }
    let(:component_instance) do
      described_class.new(title:, toggle:).tap { |dropdown| dropdown.with_item(**dropdown_item) }
    end

    before do
      allow(component_instance).to receive(:current_page?).with(dropdown_item[:path])
                                                          .and_return(true)
    end

    it "becomes active when one of its items is the current page" do
      expect(rendered_component.css("li.nav-item.dropdown.active")).to be_present
    end
  end

  describe "toggle option" do
    context "when toggle is true" do
      it "applies the 'dropdown-toggle' class" do
        expect(rendered_component.css("a.dropdown-toggle")).to be_present
      end
    end

    context "when toggle is false" do
      let(:toggle) { false }

      it "does not apply the 'dropdown-toggle' class" do
        expect(rendered_component.css("a.dropdown-toggle")).not_to be_present
      end
    end
  end

  describe "dropdown items" do
    let(:dropdown_item_1) { { path: "/test1", title: "Item 1" } }
    let(:dropdown_item_2) { { path: "/test2", title: "Item 2" } }
    let(:component_instance) do
      described_class.new(title:, toggle:).tap do |dropdown|
        dropdown.with_item(**dropdown_item_1)
        dropdown.with_item(**dropdown_item_2)
      end
    end

    it "renders provided dropdown items" do
      expect(rendered_component.css("ul.dropdown-menu li").length).to eq(2)
      expect(rendered_component.to_html).to include("Item 1")
      expect(rendered_component.to_html).to include("Item 2")
    end
  end
end
