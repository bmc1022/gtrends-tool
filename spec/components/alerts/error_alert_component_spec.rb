# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Alerts::ErrorAlertComponent, type: :component) do
  subject(:rendered_alert) { render_inline(described_class.new(resource)).to_html }

  let(:errors_double) { instance_double(ActiveModel::Errors, any?: true, messages: error_messages) }
  let(:resource)      { instance_double(User, errors: errors_double) }

  context "when multiple errors are present" do
    let(:error_messages) do
      { name: ["Name can't be blank", "Name is too short"], email: ["Email is invalid"] }
    end

    it "renders the component" do
      expect(rendered_alert).to have_css(".alert.alert-danger")
    end

    it "displays the correct number of error messages" do
      expect(rendered_alert).to have_css("ul > li", count: error_messages.keys.count)
      expect(rendered_alert).to include("Name can't be blank")
      expect(rendered_alert).to include("Email is invalid")
    end

    it "displays only the first error from each field" do
      expect(rendered_alert).to include("Name can't be blank")
      expect(rendered_alert).not_to include("Name is too short")
    end

    it "displays the correct heading text based on error count" do
      expect(rendered_alert).to include("There were 2 errors with your submission:")
    end
  end

  context "when a single error is present" do
    let(:error_messages) { { name: ["Name can't be blank", "Name is too short"] } }

    it "displays the correct heading text based on error count" do
      expect(rendered_alert).to include("There was an error with your submission:")
    end
  end

  context "when there are no errors" do
    let(:error_messages) { {} }

    before { allow(errors_double).to receive(:any?).and_return(false) }

    it "does not render the component" do
      expect(rendered_alert).to be_blank
    end
  end
end
