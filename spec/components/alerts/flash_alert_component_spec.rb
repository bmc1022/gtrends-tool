# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Alerts::FlashAlertComponent, type: :component) do
  subject(:rendered_alert) { render_inline(component_instance).to_html }

  let(:component_instance) { described_class.new }

  context "with flash messages" do
    let(:flash)           { { success: "Success", notice: "Notice", warning: "Warning" } }
    let(:mock_controller) { instance_double(ApplicationController, flash:)               }

    before { allow(component_instance).to receive(:controller).and_return(mock_controller) }

    it "renders an alert for each flash message" do
      flash.each do |type, message|
        expect(rendered_alert).to have_css(".alert-#{type}", text: message)
      end
    end

    it "renders the correct icon for each flash message type" do
      expect(rendered_alert).to have_xpath(".//div[contains(@class, 'alert-icon')]
                                              //svg//use[@*[name()='xlink:href']='#check-circle']")
      expect(rendered_alert).to have_xpath(".//div[contains(@class, 'alert-icon')]
                                              //svg//use[@*[name()='xlink:href']='#info']")
      expect(rendered_alert).to have_xpath(".//div[contains(@class, 'alert-icon')]
                                              //svg//use[@*[name()='xlink:href']='#warning']")
    end

    it "renders the close button for each flash message" do
      expect(rendered_alert).to have_css(".close-btn", count: flash.count)
    end
  end

  context "without flash messages" do
    it "does not render any alerts" do
      expect(rendered_alert).to be_blank
    end
  end
end
